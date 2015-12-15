import XCTest
@testable import JumpDetection

class JumpDetectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsPeak() {
        let manager = MotionManager()
        
        let samples1: [Double] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
        XCTAssertEqual(false, manager.isPeak(6, values: samples1), "Pass")
        
        let samples2: [Double] = [1, 3, 5, 7, 8, 11, 10, 9, 6, 4, 2]
        XCTAssertEqual(true, manager.isPeak(11, values: samples2), "Pass")
        
        let samples3: [Double] = [-0.1, -0.1, -0.2, -0.2, -0.1, -1.0, -0.1, -0.1, -0.2, -0.2, -0.1]
        XCTAssertEqual(true, manager.isPeak(-1.0, values: samples3), "Pass")
    }
    
    func testPeaksValuesFrom() {
        let manager = MotionManager()
        
        let samples1: [Double] = [
            -0.993, -0.994, -0.993, -1.016, -1.142,
            -1.482, -1.441, -1.284, -0.861, -0.416,
            -0.339, -0.287, -0.436, -0.719, -0.946,
            -1.093, -1.340]
        
        XCTAssertEqual([-1.482, -0.287], manager.peaksValuesFrom(samples1).map{$0.0}, "Pass")
        
        let samples2: [Double] = [
            -0.9910,
            -0.9871,
            -0.9901,
            -0.9848,
            -0.9933,
            -1.0161,
            -1.1416,
            -1.4824,
            -1.4414,
            -1.2843,
            -0.8609,
            -0.4162,
            -0.3394,
            -0.2871,
            -0.4361,
            -0.7191,
            -0.9463,
            -1.0934,
            -1.3405,
            -1.4641,
            -1.4017,
            -1.1228,
            -0.8631,
            -0.8195,
            -0.9055,
            -1.0161,
            -1.0439,
            -1.0142,
            -0.9733,
            -0.9666,
            -0.9752,
            -0.9924,
            -0.9873,
            -0.9871,
            -0.9773,
            -0.9860,
            -0.9867,
            -0.9856,
            -0.9849,
            -0.9800,
            -0.9828,
            -0.9807,
            -0.9835,
            -0.9883,
            -0.9878,
            -0.9838,
            -0.9790,
            -0.9802,
            -0.9843,
            -0.9855,
            -0.9873,
            -0.9870,
            -0.9806,
            -0.9804,
            -0.9754,
            -0.9720,
            -0.9783,
            -1.0235,
            -1.6638,
            -1.6447,
            -1.0677,
            -0.4529,
            -0.1602,
            -0.1644,
            -0.5783,
            -0.9515,
            -1.2385,
            -1.4119,
            -1.3073,
            -1.1084,
            -0.9859,
            -0.9137,
            -0.9372,
            -0.9768,
            -0.9397,
            -0.9933,
        ]
        
        XCTAssertEqual([-1.4824, -0.2871, -1.4641, -1.6638, -0.1602, -1.4119], manager.peaksValuesFrom(samples2).map{$0.0}, "Pass")
    }
    
}
