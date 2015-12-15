import CoreMotion

public class MotionManager {
    private let motionManager = CMMotionManager()
    private let dataPoolSize: Int
    private var previousAccelerometerData: CMAccelerometerData?
    private(set) var datas = [CMAcceleration]()
    
    private let thresholdUp = -0.4
    private let thresholdDown = -1.4
    
    public init(dataPoolSize: Int) {
        self.dataPoolSize = dataPoolSize
    }
    
    public convenience init() {
        self.init(dataPoolSize: 50)
    }
    
    func start() {
        motionManager.startAccelerometerUpdates()
    }
    
    func stop() {
        motionManager.stopAccelerometerUpdates()
    }
    
    private func collectData() {
        if let data = motionManager.accelerometerData?.acceleration {
            if datas.count < dataPoolSize {
                datas.append(data)
            } else {
                datas.removeAtIndex(0)
                datas.append(data)
            }
        }
    }
    
    func isJump() -> Bool {
        var isJump = false
        collectData()
        
        if datas.count >= dataPoolSize {
            let peaks = peaksValuesFrom(datas.map{ $0.x })
            if peaks.count == 3 {
                if matchJumpPattern(peaks.map{ $0.0} ) { // match the down-up-down paatatern
                    var indexesInRange = true
                    for peak in peaks {
                        let index = peak.1
                        if index < 10 || index > dataPoolSize-10 { // make sure the pattern is in the middle of the array to preven shaking or judging too early.
                            indexesInRange = false
                            break
                        }
                    }
                    
                    if indexesInRange {
                        datas.removeAll(keepCapacity: false)
                        isJump = true
                    }
                }
            }
        }
        return isJump
    }
    
    private func matchJumpPattern(peaks: [Double]) -> Bool {
        if peaks[1] < peaks[0] || peaks[1] < peaks[2] {
            return false
        }
        
        if peaks[1] < thresholdUp {
            return false
        }
        
        if peaks[0] > thresholdDown && peaks[2] > thresholdDown {
            return false
        }
        
        return true
    }
    
    
    
    public func peaksValuesFrom(data: [Double]) -> [(Double, Int)] {
        var peaks = [(Double, Int)]()
        let samplingSizePerSide = 4
        let samplingSize = samplingSizePerSide * 2 + 1
        
        if data.count < samplingSize {
            return peaks
        }
        
        for index in 0...data.count-samplingSize {
            let sample = Array(data[index..<index+samplingSizePerSide*2])
            let middleIndex = index + samplingSizePerSide
            let middle = data[middleIndex]
            if isPeak(middle, values: sample) && (middle > thresholdUp || middle < thresholdDown) {
                peaks.append((middle, middleIndex))
            }
        }
        
        return peaks
    }
    
    public func isPeak(value: Double, values: [Double]) -> Bool {
        let min = values.reduce(value){ $0 < $1 ? $0 : $1 }
        let max = values.reduce(value){ $0 > $1 ? $0 : $1 }
        
        if value == min || value == max {
            return true
        }
        
        return false
    }
}