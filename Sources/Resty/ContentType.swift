//
//  ContentType.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

public enum ContentType: CustomStringConvertible {
    
    // 📰 Cases ------------------------------------------ /
    
    // Text
    case plain(String? = nil)
    case xml(String? = nil)
    case html(String? = nil)
    case css(String? = nil)
    case csv(String? = nil)
    case javascript(String? = nil)
    case asp(String? = nil)
    case richtext(String? = nil)
    // Application
    case json(String? = nil)
    case octetStream(String? = nil)
    case pdf(String? = nil)
    case zip(String? = nil)
    case postscript(String? = nil)
    case java(String? = nil)
    case javaByteCode(String? = nil)
    case base64(String? = nil)
    case pksc8(String? = nil)
    case mime(String? = nil)
    // Images
    case apng(String? = nil)
    case bmp(String? = nil)
    case gif(String? = nil)
    case icon(String? = nil)
    case jpeg(String? = nil)
    case png(String? = nil)
    case svg(String? = nil)
    case tiff(String? = nil)
    case webP(String? = nil)
    case pict(String? = nil)
    // Audio
    case wave(String? = nil)
    case wav(String? = nil)
    case xWav(String? = nil)
    case xPnWav(String? = nil)
    case mpeg(String? = nil)
    case webmAudio(String? = nil)
    case oggAudio(String? = nil)
    case aiff(String? = nil)
    case vorbis(String? = nil)
    case midi(String? = nil)
    // Video
    case mp4(String? = nil)
    case avi(String? = nil)
    case quicktime(String? = nil)
    case mpegVideo(String? = nil)
    case webmVideo(String? = nil)
    case oggVideo(String? = nil)
    // Multipart
    case formData(String? = nil)
    case byteranges(String? = nil)
    // Font
    case woff(String? = nil)
    case ttf(String? = nil)
    case otf(String? = nil)
    // Model
    case vml(String? = nil)
    case iges(String? = nil)
    case threeMf(String? = nil)
    // Message
    case rfc822(String? = nil)
    case partial(String? = nil)
    // Other
    case other(String, String, String? = nil)
    
    // 💻 Computed Properties --------------------------------- /
    
    public var mimeType: String {
        switch self {
        // Text
        case .plain: return "text/plain"
        case .xml: return "text/xml"
        case .html: return "text/html"
        case .css: return "text/css"
        case .csv: return "text/csv"
        case .javascript: return "text/javascript"
        case .asp: return "text/asp"
        case .richtext: return "text/richtext"
        // Application
        case .json: return "application/json"
        case .octetStream: return "application/octet-stream"
        case .pdf: return "application/pdf"
        case .zip: return "application/zip"
        case .postscript: return "application/postscript"
        case .java: return "application/java"
        case .javaByteCode: return "application/java-byte-code"
        case .base64: return "application/base64"
        case .pksc8: return "application/pkcs8"
        case .mime: return "application/mime"
        // Images
        case .apng: return "image/apng"
        case .bmp: return "image/bmp"
        case .gif: return "image/gif"
        case .icon: return "image/x-icon"
        case .jpeg: return "image/jpeg"
        case .png: return "image/png"
        case .svg: return "image/svg+xml"
        case .tiff: return "image/tiff"
        case .webP: return "image/webp"
        case .pict: return "image/pict"
        // Audio
        case .wave: return "audio/wave"
        case .wav: return "audio/wav"
        case .xWav: return "audio/x-wav"
        case .xPnWav: return "audio/x-pn-wav"
        case .mpeg: return "audio/mpeg"
        case .webmAudio: return "audio/webm"
        case .oggAudio: return "audio/ogg"
        case .aiff: return "audio/aiff"
        case .vorbis: return "audio/vorbis"
        case .midi: return "audio/midi"
        // Video
        case .mp4: return "video/mp4"
        case .avi: return "video/avi"
        case .quicktime: return "video/quicktime"
        case .mpegVideo: return "video/mpeg"
        case .webmVideo: return "video/webm"
        case .oggVideo: return "video/ogg"
        // Multipart
        case .formData: return "multipart/form-data"
        case .byteranges: return "multipart/byteranges"
        // Font
        case .woff: return "font/woff"
        case .ttf: return "font/ttf"
        case .otf: return "font/otf"
        // Model
        case .vml: return "model/vml"
        case .iges: return "model/iges"
        case .threeMf: return "model/3mf"
        // Message
        case .rfc822: return "message/rfc822"
        case .partial: return "message/partial"
        // Other
        case .other(let type, let subType, _): return "\(type)/\(subType)"
        }
    }
    
    public var param: String? {
        switch self {
        // Text
        case .plain(let param): return param
        case .xml(let param): return param
        case .html(let param): return param
        case .css(let param): return param
        case .csv(let param): return param
        case .javascript(let param): return param
        case .asp(let param): return param
        case .richtext(let param): return param
        // Application
        case .json(let param): return param
        case .octetStream(let param): return param
        case .pdf(let param): return param
        case .zip(let param): return param
        case .postscript(let param): return param
        case .java(let param): return param
        case .javaByteCode(let param): return param
        case .base64(let param): return param
        case .pksc8(let param): return param
        case .mime(let param): return param
        // Images
        case .apng(let param): return param
        case .bmp(let param): return param
        case .gif(let param): return param
        case .icon(let param): return param
        case .jpeg(let param): return param
        case .png(let param): return param
        case .svg(let param): return param
        case .tiff(let param): return param
        case .webP(let param): return param
        case .pict(let param): return param
        // Audio
        case .wave(let param): return param
        case .wav(let param): return param
        case .xWav(let param): return param
        case .xPnWav(let param): return param
        case .mpeg(let param): return param
        case .webmAudio(let param): return param
        case .oggAudio(let param): return param
        case .aiff(let param): return param
        case .vorbis(let param): return param
        case .midi(let param): return param
        // Video
        case .mp4(let param): return param
        case .avi(let param): return param
        case .quicktime(let param): return param
        case .mpegVideo(let param): return param
        case .webmVideo(let param): return param
        case .oggVideo(let param): return param
        // Multipart
        case .formData(let param): return param
        case .byteranges(let param): return param
        // Font
        case .woff(let param): return param
        case .ttf(let param): return param
        case .otf(let param): return param
        // Model
        case .vml(let param): return param
        case .iges(let param): return param
        case .threeMf(let param): return param
        // Message
        case .rfc822(let param): return param
        case .partial(let param): return param
        // Other
        case .other(_, _, let param): return param
        }
    }
    
    public var description: String {
        if let param = self.param {
            return "\(mimeType);\(param)"
        } else {
            return mimeType
        }
    }
    
    public var type: String { String(mimeType.split(separator: "/")[0]) }
    
    public var subType: String { String(mimeType.split(separator: "/")[1]) }
    
    // Static --------------------------------- /

    public static let key = "Content-Type"
}
