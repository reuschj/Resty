import XCTest
@testable import Resty

final class RestyTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual("Hello, World!", "Hello, World!")
    }
    
    func testURLParams() {
        let params = URLParams(with: [
            URLParamItem(key: "year", value: "2020"),
            URLParamItem(key: "month", value: "April"),
            URLParamItem(key: "day", value: "01")
        ])
        XCTAssertTrue(params.count == 3)
        XCTAssertEqual(params.description, "2020/April/01")
    }
    
    func testCall() {
        Resty.get("https://financialmodelingprep.com/api/v3/quote/AAPL,FB") {response in
            switch response.result {
            case .success(let data):
                XCTAssertEqual(response.statusCode, 200)
                print("Status Code:", response.statusCode)
                XCTAssertEqual(response.url, URL(string: "https://financialmodelingprep.com/api/v3/quote/AAPL,FB"))
                print("URL:", response.url ?? "NA")
                XCTAssertEqual(response.mimeType, "application/json")
                print("MIME Type:", response.mimeType ?? "None")
                let dataString = String(data: data, encoding: .utf8)!
                XCTAssert(dataString.count > 0)
                XCTAssert(dataString.contains("AAPL"))
                XCTAssert(dataString.contains("marketCap"))
                XCTAssert(dataString.contains("FB"))
                print("Data:")
                print(dataString)
            case .failure(let restCallError):
                let errorDescription = String(describing: restCallError)
                XCTFail(errorDescription)
            }
        }
    }

    static var allTests = [
        ("testExample", testExample),
        ("testURLParams", testURLParams),
        ("testCall", testCall),
    ]
}
