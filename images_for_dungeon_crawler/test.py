from __future__ import division
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

    
def get_line_equation(x1, y1, x2, y2):
    # y = mx + b
    m = (y2 - y1) / (x2 - x1)
    b = y1 - m*x1
    def func(x=None, y=None):
        if x is None and y is None:
            raise ValueError('One of the argumentes must not be null')
        if x is not None:
            return m*x + b
        else:
            return (y-b) / m
    return func
       
    
    
    
x = find_coeffs([(0, 0), (256, 128), (256, 384), (0, 512)],
                [(0, 0), (512, 0), (512, 512), (0, 512)])


X_PARTS = 8
Y_PARTS = 3

                
                
img = Image.open('final_wall.png')

original_size = img.size
x_size = original_size[0]
y_size = original_size[1]

center = tuple( x/2 for x in original_size)

x_part = x_size / X_PARTS
y_part = y_size / Y_PARTS

vp = (0, -(y_part/2) if Y_PARTS % 2 != 0 else 0)
vanishing_point = tuple(sum(x) for x in zip(center, vp))


# far. -1 X part
def far(n_parts, image, result_filename):
    part = x_part * n_parts

    # up left corner
    f1 = get_line_equation(0, 0, *vanishing_point)
    tmp = f1(x=part)
    up_left = (part, tmp)
    
    # up right corner
    f2 = get_line_equation(x_size, 0, *vanishing_point)
    tmp = f2(x=(x_size-part))
    up_right = (x_size-part, tmp)
    
    # down left corner
    f3 = get_line_equation(0, y_size, *vanishing_point)
    tmp = f3(x=part)
    down_left = (part, tmp)
    
    # down right corner
    f4 = get_line_equation(x_size, y_size, *vanishing_point)
    tmp = f4(x=(x_size-part))
    down_right = (x_size-part, tmp)
    
    print up_left
    print up_right
    print down_left
    print down_right
    
    coeffs = find_coeffs([up_left, up_right, down_right, down_left],
                         [(0, 0), (x_size, 0), (x_size, y_size), (0, y_size)])
                         
    new_image = image.transform((original_size), Image.PERSPECTIVE, coeffs, Image.BICUBIC)
    new_image.save(result_filename, 'PNG')
    
    
    
def corridor(from_n_part, to_n_part, image, result_filename):
    from_part = from_n_part * x_part
    to_part = to_n_part * x_part
    
    # left segment
    
    # top left
    f1 = get_line_equation(
    
    
# far(1, img, 'far.png')

    





                