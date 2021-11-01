import ArgumentParser
import Foundation

/// 将蓝湖下载的资源文件整合到 Flutter 对应的图片路径
struct FlutterAsset: ParsableCommand {
    
    @Argument(help: "1x@2x@3x的图片文件夹地址")
    var source:String
    
    @Option(help: "保存的文件夹地址")
    var to:String?
    
    @Flag(help: "是否允许同名图片存在重写")
    var allowRewrite:Bool = false
    
    mutating func run() throws {
        let _to:String
        if let to = to {
            _to = to
        } else if let pwd = ProcessInfo.processInfo.environment["PWD"] {
            _to = pwd + "/images"
        } else {
            throw NSError(domain: "$PWD参数不存在", code: -1, userInfo: nil)
        }
        var isToExit:ObjCBool = .init(false)
        if !FileManager.default.fileExists(atPath: _to, isDirectory: &isToExit) {
            print("导出的路径不存在: \(_to)")
        } else if !isToExit.boolValue {
            print("导出的路径不是文件夹: \(_to)")
        }
        print("当前导出的路径为:\(_to)")
        let contents = try FileManager.default.contentsOfDirectory(atPath: source)
        for content in contents {
            try _saveImage(imageName: content, toPath: _to)
        }
        print("✅复制文件成功!")
    }
    
    func _saveImage(imageName:String, toPath:String) throws {
        let fileName = try _fileName(imageName: imageName)
        let _toPath:String
        if imageName.contains("@2x") {
            _toPath = "\(toPath)/2.0x"
        } else if imageName.contains("@3x") {
            _toPath = "\(toPath)/3.0x"
        } else {
            _toPath = toPath
        }
        try _createPathIfNotExit(filePath: _toPath)
        let toImagePath = "\(_toPath)/\(fileName)"
        if allowRewrite, FileManager.default.fileExists(atPath: toImagePath) {
            /// 同名的资源已经存在 则删除之前的图片
            try FileManager.default.removeItem(at: URL(fileURLWithPath: toImagePath))
        }
        try FileManager.default.copyItem(atPath: "\(source)/\(imageName)",
                                         toPath: toImagePath)
    }
    
    func _fileName(imageName:String) throws -> String {
        let names = imageName.components(separatedBy: "@")
        guard names.count <= 2 else {
            throw NSError(domain: "\(imageName)包含多个@符号", code: -1, userInfo: nil)
        }
        if names.count == 1 {
            return names[0]
        } else {
            return "\(names[0]).png"
        }
    }
    
    func _createPathIfNotExit(filePath:String) throws {
        var isDirectory:ObjCBool = .init(false)
        guard !FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory) else {
            guard isDirectory.boolValue else {
                throw NSError(domain: "当前路径不是一个目录", code: -1, userInfo: nil)
            }
            return
        }
        
        try FileManager.default.createDirectory(at: URL(fileURLWithPath: filePath),
                                                withIntermediateDirectories: true,
                                                attributes: nil)
    }
}

FlutterAsset.main()
