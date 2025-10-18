import XCTest
@testable import appleMyCore

final class appleMyCoreTests: XCTestCase {
    func testHeartRateSampleEncoding() throws {
        let sample = HeartRateSample(bpm: 72)
        let data = try JSONEncoder().encode(sample)
        let decoded = try JSONDecoder().decode(HeartRateSample.self, from: data)
        XCTAssertEqual(decoded.bpm, sample.bpm)
    }

    func testHealthEngineStubSave() throws {
        let engine = HealthEngine()
        let expectation = XCTestExpectation(description: "save")
        let sample = HeartRateSample(bpm: 60)
        engine.saveHeartRate(sample) { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testBLEStubStartStop() {
        let source = BLEHeartRateSource()
        source.start()
        source.stop()
        XCTAssertTrue(true)
    }
}
