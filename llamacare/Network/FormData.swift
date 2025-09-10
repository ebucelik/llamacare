//
//  FormData.swift
//  Vocalove
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 20.10.24.
//

public class FormData {
    public enum DataType {
        case jpg
        case m4a

        var withName: String {
            "media"
        }

        var fileName: String {
            switch self {
            case .jpg:
                "image.jpg"
            case .m4a:
                "audio.m4a"
            }
        }

        var mimeType: String {
            switch self {
            case .jpg:
                "image/jpg"
            case .m4a:
                "audio/m4a"
            }
        }
    }
}
