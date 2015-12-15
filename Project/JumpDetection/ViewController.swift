import UIKit
import GLKit

let dataPoolSize: Int = 50
let filterSampleRate: Int = 5
let standardizationScale: Double = 2.0
class ViewController: GLKViewController {
    
    @IBOutlet private var glkView: GLKView!
    
    private let motionManager = MotionManager(dataPoolSize: dataPoolSize)//, sampleingRate: filterSampleRate)
    
    private var recording: Bool = false
    private var recordedData = [Double]()
    
    let positions: [GLfloat] = [
        1.0, -0.01, 0.0,
        1.0, 0.01, 0.0,
        -1.0, -0.01, 0.0,
        -1.0, 0.01, 0.0
    ]
    
    let colors: [GLfloat] = [
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 1.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        glkView.context = EAGLContext(API: .OpenGLES1)
        glkView.delegate = self
        
        glkView.drawableColorFormat = .RGBA8888
        glkView.drawableDepthFormat = .Format24
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        becomeFirstResponder()
        motionManager.start()
        NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("jumpDectection"), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        motionManager.stop()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func jumpDectection() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if self.motionManager.isJump() {
                print("jump dectected")
            }
        })
    }
    
}

extension ViewController: GLKViewControllerDelegate {
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        // Clear the framebuffer
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(UInt32(GL_COLOR_BUFFER_BIT) | UInt32(GL_DEPTH_BUFFER_BIT))
        
        /* white line*/
        glMatrixMode(GLenum(GL_PROJECTION))
        glLoadIdentity()
        
        glVertexPointer(3,GLenum(GL_FLOAT), 0, positions)
        glColorPointer(4, GLenum(GL_FLOAT), 0, colors)
        
        glEnableClientState(GLenum(GL_VERTEX_ARRAY))
        glEnableClientState(GLenum(GL_COLOR_ARRAY))
        
        glPushMatrix()
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
        glPopMatrix()
        glFlush()
        
        /* quad */
        let xPortion: Float = 2.0 / Float(dataPoolSize)
        var x: Float = -1.0
        for d in motionManager.datas {
            let quad = Quad(color: .Red, scale: (xPortion, xPortion))
            quad.drawAt(x: x, y: GLfloat(d.x/standardizationScale))
            x += xPortion
        }
    }

    func glkViewControllerUpdate(controller: GLKViewController) {
    }
}

