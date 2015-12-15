import GLKit

class Quad {
    
    enum Color {
        case Red, Blue, Green
    }
    private let color: Color
    private let scale: (x: Float, y: Float)
   
    let positions: [GLfloat] = [
        1.0, 0.0, 0.0,
        1.0, 1.0, 0.0,
        0.0, 0.0, 0.0,
        0.0, 1.0, 0.0
    ]
    
    init(color: Color, scale: (Float, Float)) {
        self.color = color
        self.scale = scale
    }
    
    convenience init() {
        self.init(color: .Red, scale: (1.0, 1.0))
    }
    
    convenience init(color: Color) {
        self.init(color: color, scale: (1.0, 1.0))
    }
    
    
    private func colorData(color: Color) -> [GLfloat] {
        switch color {
        case .Red:
            return [
                1.0, 0.0, 0.0, 1.0,
                1.0, 0.0, 0.0, 1.0,
                1.0, 0.0, 0.0, 1.0,
                1.0, 0.0, 0.0, 1.0
            ]
        case .Green:
            return [
                0.0, 1.0, 0.0, 1.0,
                0.0, 1.0, 0.0, 1.0,
                0.0, 1.0, 0.0, 1.0,
                0.0, 1.0, 0.0, 1.0
            ]
        case .Blue:
            return [
                0.0, 0.0, 1.0, 1.0,
                0.0, 0.0, 1.0, 1.0,
                0.0, 0.0, 1.0, 1.0,
                0.0, 0.0, 1.0, 1.0
            ]
        }
    }
    
    func draw() {
        drawAt(x: 0.0, y: 0.0)
    }
    
    func drawAt(x x: GLfloat, y: GLfloat) {
        glMatrixMode(GLenum(GL_PROJECTION))
        glLoadIdentity()
        
        glVertexPointer(3,GLenum(GL_FLOAT), 0, positions)
        glColorPointer(4, GLenum(GL_FLOAT), 0, colorData(color))
        
        glEnableClientState(GLenum(GL_VERTEX_ARRAY))
        glEnableClientState(GLenum(GL_COLOR_ARRAY))
        
        glPushMatrix()
        glTranslatef(x, y, 0.0)
        glScalef(scale.x, scale.y, 1.0)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
        glPopMatrix()
        glFlush()
    }
}