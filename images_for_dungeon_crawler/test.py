from PIL import Image
import numpy

def find_coeffs(pa, pb):
    matrix = []
    for p1, p2 in zip(pa, pb):
        matrix.append([p1[0], p1[1], 1, 0, 0, 0, -p2[0]*p1[0], -p2[0]*p1[1]])
        matrix.append([0, 0, 0, p1[0], p1[1], 1, -p2[1]*p1[0], -p2[1]*p1[1]])

    A = numpy.matrix(matrix, dtype=numpy.float)
    B = numpy.array(pb).reshape(8)

    res = numpy.dot(numpy.linalg.inv(A.T * A) * A.T, B)
    return numpy.array(res).reshape(8)
    
x = find_coeffs([(0, 0), (256, 128), (256, 384), (0, 512)],
                [(0, 0), (512, 0), (512, 512), (0, 512)])
                
                
im = Image.open('wall.png')

img = im.transform((512, 512), Image.PERSPECTIVE, x, Image.BICUBIC)

img.save('cenas.png', 'PNG')
                