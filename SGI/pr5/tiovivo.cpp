#include <GL/glut.h>

GLuint anillo(float diamExt, float diamInt, float grosor, float res = 20){


}

void display() {
    glClear(GL_COLOR_BUFFER_BIT);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    // Mover la tetera a la esquina superior izquierda
    glTranslatef(-0.7, 0.7, 0.0);  // X negativo (izquierda), Y positivo (arriba)
    glutSolidTeapot(0.3);  // Reducí un poco el tamaño para que quede mejor
    
    glFlush();
}

int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowSize(500, 500);
    glutInitWindowPosition(100, 100);
    glutCreateWindow("Tetera Arriba-Izquierda");
    
    // Configurar la proyección ortográfica
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(-1.0, 1.0, -1.0, 1.0);  // Sistema de coordenadas normalizado
    
    glutDisplayFunc(display);
    
    glutMainLoop();
    return 0;
}