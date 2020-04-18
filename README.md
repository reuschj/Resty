# Resty

Resty (full name, [Resty McRestface](https://en.wikipedia.org/wiki/Boaty_McBoatface) 😂), is a REST client for Swift to make REST API calls a bit easier. Behind the scenes, Resty is just using standard Swift APIs (forming a `URLRequest`, sending over a `URLSession` and handling a `HTTPURLResponse` response). However, it wraps these in a more convenient, more expressive, more concise syntax.

Resty is very much a work in progress, so feedback and real-world testing is very much needed. Some areas are well-documented, other areas are less so. Also, some more advanced features are only partially built out. However, most basic REST API calls should be possible as-is.

More detailed documentation will come soon. In the meantime, here is a very basic example:

```swift
do {
    try Resty.get("https://httpbin.org/json") { response in
        switch response.result {
            case .success(let data):
                print("Status Code:", response.statusCode)
                let dataString = String(data: data, encoding: .utf8)!
                print(dataString)
            case .failure(let restCallError):
                let errorDescription = String(describing: restCallError)
        }
    }
} catch {
    let errorMessage = String(describing: error)
    print(errorMessage)
}
```

Or, something like this: 

```swift
struct Freeform: Codable {
    var contentLength: String
    var contentType: String
    var freeform: String

    enum CodingKeys: String, CodingKey {
        case contentLength = "Content-Length"
        case contentType = "Content-Type"
        case freeform
    }
}
let urlQueries = URLQueries(with: [
    URLQueryItem(name: "freeform", value: "This is a test string")
])
do {
    try Resty.decode("https://httpbin.org/response-headers", method: .post, type: Freeform.self, queries: urlQueries) { response, result in
        switch result {
        case .success(let freeform):
            print("Status Code:", response.statusCode)
            print(freeform.freeform)
        case .failure(let restCallError):
            let errorDescription = String(describing: restCallError)
        }
    }
} catch {
    let errorMessage = String(describing: error)
    print(errorMessage)
}
