import XCTest
@testable import Resty

final class RestyTests: XCTestCase {
    
    func testURLParams() {
        var params = URLParams(with: [
            URLParamItem(key: "year", value: "2020"),
            URLParamItem(key: "month", value: "April"),
            URLParamItem(key: "day", value: "01")
        ])
        XCTAssertTrue(params.count == 3)
        XCTAssertEqual(params.description, "2020/April/01")
        params.setValue("12", forKey: "hour")
        XCTAssertTrue(params.count == 4)
        XCTAssertEqual(params.description, "2020/April/01/12")
        let removed = params.remove(key: "month")
        XCTAssertEqual(removed, "April")
        XCTAssertTrue(params.count == 3)
        XCTAssertEqual(params.description, "2020/01/12")
        let removed2 = params.remove(key: "year")
        XCTAssertEqual(removed2, "2020")
        XCTAssertTrue(params.count == 2)
        XCTAssertEqual(params.description, "01/12")
        params.setValue("15", forKey: "day")
        XCTAssertEqual(params.description, "15/12")
    }
    
    func testCall() {
        Resty.get("https://financialmodelingprep.com/api/v3/quote/AAPL,FB") { response in
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
        ("testURLParams", testURLParams),
        ("testCall", testCall),
    ]
}
