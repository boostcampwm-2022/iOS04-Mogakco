//
//  DefaultImageCacheService.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/06.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum ImageCacheError: Error {
    case nilPathError
    case nilImageError
    case invalidURLError
    case imageNotModifiedError
    case networkUsageExceedError
    case unknownNetworkError
}

struct ImageCache { // 내부 (메모리) 캐시 
    private(set) var maximumDiskSize: Int = 0
    private(set) var currentDiskSize: Int = 0
    private var cache = NSCache<NSString, CacheableImage>()
    
    /// 캐시정책
    mutating func configureCachePolicy(with maximumMemoryBytes: Int, with maximumDiskBytes: Int) {
        self.cache.totalCostLimit = maximumMemoryBytes // 캐시 한도(메모리)
        self.maximumDiskSize = maximumDiskBytes // 캐시 한도(디스크)
        self.currentDiskSize = self.countCurrentDiskSize()
        // 현재 디스크 사이즈
    }
    
    /// 디스크 사용시 용량 사이즈 위한 update
    mutating func updateCurrentDiskSize(with itemSize: Int) {
        self.currentDiskSize += itemSize
    }
    
    /// 캐시에 저장
    mutating func save(data: CacheableImage, with key: String) {
        let key = NSString(string: key)
        self.cache.setObject(data, forKey: key, cost: data.imageData.count)
    }
    
    /// 캐시 데이터 불러오기
    func read(with key: String) -> CacheableImage? {
        let key = NSString(string: key)
        return self.cache.object(forKey: key)
    }
    
    /// 현재 디스크 용량 계산
    private func countCurrentDiskSize() -> Int {
        // 파일을 저장 또는 불러오려면 파일의 위치를 알아야 하는데 파일의 위치는 URL로 표현 할 수 있다.
        let cacheDirectoryPath = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask)
        
        // url(for: 접근할 디렉토리, in: 접근 옵션으로 디렉토리에 대한 기본 위치 지정)
        
        guard let path = cacheDirectoryPath.first else { return 0 }
        
        // 만약 파일의 경로가 App/A/B.jepg 라고 하면
        // path.appendingPathComponent("A")
        // path.appendingPathComponent("B.jpeg")
        
        let profileImagePath = path.appendingPathComponent("profileImage")
        
        
        // 생성한 경로로 부터 contents 받아오기
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: profileImagePath.path) else {
            return 0
        }
        
        
        var totalSize = 0
        
        // contents를 순환하면서
        for content in contents {
            // 마지막에 파일 이름까지 붙인 최종 경로를 생성
            let fullContentPath = profileImagePath.appendingPathComponent(content)
            // 아이템 속성 가져와서
            let fileAttributes = try? FileManager.default.attributesOfItem(atPath: fullContentPath.path)
            // 사용 용량을 확인한다.
            totalSize += fileAttributes?[FileAttributeKey.size] as? Int ?? 0
        }
        return totalSize
    }
}

final class DefaultImageCacheService { // 외부 캐시 매니저
    static let shared = DefaultImageCacheService()
    private var cache = ImageCache() // 메모리 캐시
    private init () {}
    
    func configureCache(with maximumMemoryBytes: Int, with maximumDiskBytes: Int) { // 캐시 초기화
        self.cache.configureCachePolicy(with: maximumMemoryBytes, with: maximumDiskBytes)
    }
    
    func setImage(_ imageURL: URL) -> Observable<Data> { // 이미지 저장하기 위한 메서드
        
        guard let imageURL = URL(string: "\(imageURL)") else {
            return Observable.error(ImageCacheError.invalidURLError)
        }

        // NSCache 확인
        if let image = self.checkMemory(imageURL) { // CacheableImage 데이터가 있다면
            print("DEBUG : NSCache")
            return self.get(imageURL: imageURL, etag: image.cacheInfo.etag)
                .map({ $0.imageData })
                .catchAndReturn(image.imageData)
        }
        
        // Disk 확인
        if let image = self.checkDisk(imageURL) {
            print("DEBUG : Disk")
            return self.get(imageURL: imageURL, etag: image.cacheInfo.etag)
                .map({ $0.imageData })
                .catchAndReturn(image.imageData)
        }
        
        // 모두 패스 시 Request
        return self.get(imageURL: imageURL)
            .map({ $0.imageData })
    }
    
    
    private func get(imageURL: URL, etag: String? = nil) -> Observable<CacheableImage> {
        return Observable<CacheableImage>.create { emitter in
            var request = URLRequest(url: imageURL)
            // etag 가져온다(데이터 변경 사항이 있는지)
            if let etag = etag {
                request.addValue(etag, forHTTPHeaderField: "If-None-Match")
            }
            
            let disposable = URLSession.shared.rx.response(request: request).subscribe(
                onNext: { [weak self] response, data in
                    switch response.statusCode {
                    case (200...299): // 네트워크 성송시
                        print("DEBUG : ETAG 200..299")
                        // etag 가져오고, 이미지 데이터 전환하고 cache와 disk에 저장
                        let etag = response.allHeaderFields["Etag"] as? String ?? ""
                        let image = CacheableImage(imageData: data, etag: etag)
                        self?.saveIntoCache(imageURL: imageURL, image: image)
                        self?.saveIntoDisk(imageURL: imageURL, image: image)
                        emitter.onNext(image)
                    case 304:
                        print("DEBUG : ETAG 304")
                        emitter.onError(ImageCacheError.imageNotModifiedError)
                    case 402:
                        print("DEBUG : ETAG 402")
                        emitter.onError(ImageCacheError.networkUsageExceedError)
                    default:
                        print("DEBUG : ETAG default")
                        emitter.onError(ImageCacheError.unknownNetworkError)
                    }
                },
                onError: { error in
                    emitter.onError(error)
                }
            )
            
            return Disposables.create(with: disposable.dispose)
        }
    }
    
    /// 캐시 확인
    private func checkMemory(_ imageURL: URL) -> CacheableImage? {
        // chache에서 데이터를 가져옴
        guard let cached = self.cache.read(with: imageURL.path) else { return nil }
        // cache hit했으면 시간 update
        self.updateLastRead(of: imageURL, currentEtag: cached.cacheInfo.etag)
        return cached
    }
    
    private func checkDisk(_ imageURL: URL) -> CacheableImage? {
        guard let filePath = self.createImagePath(with: imageURL) else { return nil }
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath),
                  let cachedData = UserDefaults.standard.data(forKey: imageURL.path),
                  let cachedInfo = self.decodeCacheData(data: cachedData) else { return nil }
            
            let image = CacheableImage(imageData: imageData, etag: cachedInfo.etag)
            self.saveIntoCache(imageURL: imageURL, image: image)
            self.updateLastRead(of: imageURL, currentEtag: cachedInfo.etag, to: image.cacheInfo.lastRead)
            
            return image
        }
        return nil
    }
    
    /// 최근 읽은 시간 update
    private func updateLastRead(of imageURL: URL, currentEtag: String, to date: Date = Date()) {
        // etag와 최근에 읽은 시간인 lastRead date를 프로퍼티로 갖고 있는 CacheInfo를 생성
        let updated = CacheInfo(etag: currentEtag, lastRead: date)
        // encoding 하고 userDefaults에 저장된 값인지 확인
        guard let encoded = encodeCacheData(cacheInfo: updated),
              UserDefaults.standard.object(forKey: imageURL.path) != nil else { return }
        
        UserDefaults.standard.set(encoded, forKey: imageURL.path)
    }
    
    /// 캐시에 저장(NSCache)
    private func saveIntoCache(imageURL: URL, image: CacheableImage) {
        self.cache.save(data: image, with: imageURL.path)
    }
    
    /// Disk에 저장
    private func saveIntoDisk(imageURL: URL, image: CacheableImage) {
        // filePath를 불러온다.(없으면 생성)
        guard let filePath = self.createImagePath(with: imageURL) else { return }
        
        // etag와 최근 읽은 시간 저장
        let cacheInfo = CacheInfo(etag: image.cacheInfo.etag, lastRead: Date())
        let targetByteCount = image.imageData.count
        
        // 1. 저장하려는 이미지의 데이터가 맥시멈 사이즈 이하여야 하고
        // 2. 작은데 현재 용량 + 이미지 용량이 맥시멈 사이즈를 초과하는 동안 용량이 나올 때 까지 지울 것을 찾는다.
        // 용량 나오면 2번에 의해 while문 빠져나옴
        while targetByteCount <= self.cache.maximumDiskSize
                && self.cache.currentDiskSize + targetByteCount > self.cache.maximumDiskSize {
            var removeTarget: (imageURL: String, minTime: Date) = ("", Date())
            
            // UserDefaults 저장된 파일들 순환
            UserDefaults.standard.dictionaryRepresentation().forEach({ key, value in
                guard let cacheInfoData = value as? Data,
                      let cacheInfoValue = self.decodeCacheData(data: cacheInfoData) else { return }
                
                // 순환을 하면서 1. 오래된 애를 removeTarget에 넣으면서 계속 그 시간들을 비교하여 가장 오래된 애를 찾아냄
                if removeTarget.minTime > cacheInfoValue.lastRead {
                    removeTarget = (key, cacheInfoValue.lastRead) // 해당 데이터를
                }
            })
            self.deleteFromDisk(imageURL: removeTarget.imageURL) // 지운다.
        }
        
        // 1.의 이유가 아닌 2번의 이유로 만약 현재 캐시용량과 타겟 이미지 용량을 더한 값이 맥시멈을 안넘어가면
        if self.cache.currentDiskSize + targetByteCount <= self.cache.maximumDiskSize {
            // 인코딩하여
            guard let encoded = encodeCacheData(cacheInfo: cacheInfo) else { return }
            // UserDefault에 저장하고
            UserDefaults.standard.set(encoded, forKey: imageURL.path)
            // Disk에 저장
            FileManager.default.createFile(atPath: filePath.path, contents: image.imageData, attributes: nil)
            // cache 총 용량 update
            self.cache.updateCurrentDiskSize(with: targetByteCount)
        }
    }
    
    /// Disk에서 삭제
    private func deleteFromDisk(imageURL: String) {
        // 이미지 경로로 file 경로를 만든 뒤 해당 경로에 잇는 파일의 속성들을 가져와
        guard let imageURL = URL(string: imageURL),
              let filePath = self.createImagePath(with: imageURL),
              let targetFileAttribute = try? FileManager.default.attributesOfItem(atPath: filePath.path) else { return }
        
        // 사이즈 값을 가져오고
        let targetByteCount = targetFileAttribute[FileAttributeKey.size] as? Int ?? 0
        
        do {
            // 해당 파일 경로의 데이터를 삭제하고
            try FileManager.default.removeItem(atPath: filePath.path)
            // UserDefault도 삭제한다.
            UserDefaults.standard.removeObject(forKey: imageURL.path)
            // 그리고 총 용량에서 그 만큼 빼준다.
            self.cache.updateCurrentDiskSize(with: targetByteCount * -1)
        } catch {
            return
        }
    }
    
    private func decodeCacheData(data: Data) -> CacheInfo? {
        return try? JSONDecoder().decode(CacheInfo.self, from: data)
    }
    
    private func encodeCacheData(cacheInfo: CacheInfo) -> Data? {
        return try? JSONEncoder().encode(cacheInfo)
    }
    
    private func createImagePath(with imageURL: URL) -> URL? {
        // 디스크 경로 초기화 (FileManager의 디스크 접근할 디렉토리와 접근 옵션 지정)
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else { return nil }
        // App/profileImage
        let profileImageDirPath = path.appendingPathComponent("profileImage")
        // App/profileImage/이-미-지-path
        let filePath = profileImageDirPath.appendingPathComponent(imageURL.pathComponents.joined(separator: "-"))
        
        if !FileManager.default.fileExists(atPath: profileImageDirPath.path) {
            // 파일 쓰기
            try? FileManager.default.createDirectory( // 디렉토리 생성
                atPath: profileImageDirPath.path, // 디렉토리 경로
                withIntermediateDirectories: true, // true: 중간 경로가 없더라도 알아서 만듦 false: 메소드 실패
                attributes: nil //  생성된 디렉토리에 대한 파일 속성이며 파일 권한 및 수정 날짜 등을 설정 가능
                // nil 사용 시 기본값으로 설정됨
            )
        }
        return filePath
    }
}
