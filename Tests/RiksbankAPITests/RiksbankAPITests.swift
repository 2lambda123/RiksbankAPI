import XCTest
@testable import RiksbankAPI

final class RiksbankAPITests: XCTestCase {
    
    func testCalendarDays() {
        
        let expectation = XCTestExpectation(description: "Fetch information about bank days.")
        
        let today = Date()
        let threeMonthsFromToday = Calendar.current.date(byAdding: .month, value: 3, to: Date())!
        let cancellable = RiksbankService().calendarDays(interval: today...threeMonthsFromToday)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    print("Error: \(error.localizedDescription)")
                    XCTFail()
                }
                expectation.fulfill()
            }, receiveValue: {
                dump($0)
            })
        _ = cancellable
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testCrossRateNames() {
        
        let expectation = XCTestExpectation(description: "Fetch exchange rate names.")
        
        let cancellable = RiksbankService().allCrossNames(language: .swedish)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    print("Error: \(error.localizedDescription)")
                    XCTFail()
                }
                expectation.fulfill()
            }, receiveValue: {
                dump($0)
            })
        _ = cancellable
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testCrossRates() {

        let expectation = XCTestExpectation(description: "Fetch exchange rate information.")

        let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let cancellable = RiksbankService().crossRates(aggregateMethod: .daily,
                                     crossPairs: [CurrencyCrossPair(seriesID1: "SEKUSDPMI", seriesID2: "SEK")],
                                     interval: dayBeforeYesterday...yesterday,
                                     language: .swedish)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    print("Error: \(error.localizedDescription)")
                    XCTFail()
                }
                expectation.fulfill()
            }, receiveValue: {
                dump($0)
            })
        _ = cancellable
        
        wait(for: [expectation], timeout: 10.0)
    }

    static var allTests = [
        ("testCalendarDays", testCalendarDays),
        ("testCrossRateNames", testCrossRateNames),
        ("testCrossRates", testCrossRates)
    ]
}
