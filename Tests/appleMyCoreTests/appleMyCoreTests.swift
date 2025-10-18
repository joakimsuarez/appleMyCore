import XCTest
@testable import appleMyCore

final class appleMyCoreTests: XCTestCase {
    func testHeartRateSampleEncoding() throws {
        let sample = HRSample(bpm: 72)
        let data = try JSONEncoder().encode(sample)
        let decoded = try JSONDecoder().decode(HRSample.self, from: data)
        XCTAssertEqual(decoded.bpm, sample.bpm)
    }

    func testHealthEngineStubSave() throws {
        let engine = HealthEngineImpl()
        let expectation = XCTestExpectation(description: "save")
        let sample = HRSample(bpm: 60)
        engine.saveHR(sample) { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testBLEStubStartStop() {
        let source = BLEHeartRateSourceImpl()
        source.start()
        source.stop()
        XCTAssertTrue(true)
    }
}
