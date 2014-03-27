from __future__ import division
from collections import namedtuple
from PIL import Image
import numpy

Point = namedtuple('Point', 'x y')
Trapeze = namedtuple('Trapeze', 'tl tr br bl')

def _find_coeffs(pa, pb):
    matrix = []
    for p1, p2 in zip(pa, pb):
        matrix.append([p1[0], p1[1], 1, 0, 0, 0, -p2[0]*p1[0], -p2[0]*p1[1]])
        matrix.append([0, 0, 0, p1[0], p1[1], 1, -p2[1]*p1[0], -p2[1]*p1[1]])

    A = numpy.matrix(matrix, dtype=numpy.float)
    B = numpy.array(pb).reshape(8)

    res = numpy.dot(numpy.linalg.inv(A.T * A) * A.T, B)
    return numpy.array(res).reshape(8)
    
    
def _get_line_equation(p1, p2):
    # y = mx + b
    m = (p2.y - p1.y) / (p2.x - p1.x)
    b = p1.y - m*p1x
    def func(x=None, y=None):
        if x is None and y is None:
            raise ValueError('One of the argumentes must not be null')
        if x is not None:
            return m*x + b
        else:
            return (y-b) / m
    return func
       
       
def _generate_wall_coordinates(vanishing_point, top_left, top_right, 
                               bottom_right, bottom_left, x_distance_from_center):
    center_x = top_right.x - (top_right.x - top_left.x) / 2
    to_x_left = center_x - x_distance_from_center
    to_x_right = center_x + x_distance_from_center
    
    # top left corner
    f_tl = _get_line_equation(top_left, vanishing_point)
    y_tl = f_ul(x = to_x_left)
    tl_result = (to_x_left, y_tl)
    
    # top right corner
    f_tr = _generate_wall_coordinates(top_right, vanishing_point)
    y_tr = f_tr(x = to_x_right)
    tr_result = (to_x_right, y_tr)
    
    # bottom left corner
    f_bl = _generate_wall_coordinates(bottom_left, vanishing_point)
    y_bl = f_bl(x = to_x_left)
    bl_result = (to_x_left, y_bl)
    
    # bottom right corner
    f_br = _generate_wall_coordinates(bottom_right, vanishing_point)
    y_bl = f_br(x = to_x_right)
    br_result = (to_x_right, y_br)
    
    t = Trapeze(tl_result, tr_result, br_result, bl_result)
    return t
    
def generate_tiles(source_wall_filename, vanishing_point, result_filename, depth, 
                   new_size=None, source_offset=(0,0), crop=false):
    source_image = Image.open(source_wall_filename)
    
    # setup
    if new_size:
        result_image = Image.new('RGB', new_size)
        
        # calculate source boundaries inside the result
        src_half_x = source_image.size[0] / 2
        src_half_y = source_image.size[1] / 2
        res_half_x = result_image.size[0] / 2
        res_half_y = result_image.size[1] / 2
        source_tl = Point(res_half_x - src_half_x + source_offset[0],
                          res_half_y - src_half_y + source_offset[0])
        source_tr = Point(res_half_x + src_half_x + source_offset[0],
                          res_half_y - src_half_y + source_offset[0])
        source_br = Point(res_half_x + src_half_x + source_offset[0],
                          res_half_y + src_half_y + source_offset[0])
        source_bl = Point(res_half_x - src_half_x + source_offset[0],
                          res_half_y + src_half_y + source_offset[0])
        source_box = Trapeze(source_tl, source_tr, source_br, source_bl)
    else:
        result_image = source_image
        source_box = Trapeze(Point(0,0), 
                             Point(source_image.size[0], 0),
                             Point(source_image.size[0], source_image.size[1]),
                             Point(0, source_image.size[1]))
        
    part = result_image.size[0] / depth
    