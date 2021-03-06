//******************************************************************************
//
// Copyright (c) 2015 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#include "Starboard.h"

#include "UIKit/NSParagraphStyle.h"
#include <CGPathInternal.h>

@implementation NSTextContainer {
    CGSize _size;
    NSLayoutManager* _layoutManager;
    idretaintype(NSArray) _exclusionPaths;
}

/**
 @Status Interoperable
*/

- (instancetype)initWithSize:(CGSize)size {
    _size = size;
    _lineFragmentPadding = 5.0f;

    return self;
}

/**
 @Status Interoperable
*/

- (void)setSize:(CGSize)size {
    _size = size;

    [_layoutManager textContainerChangedGeometry:self];
}

/**
 @Status Caveat

 @Notes Only CGPath objects containing lines are supported
*/

- (void)setExclusionPaths:(NSArray*)paths {
    _exclusionPaths.attach([paths copy]);

    [_layoutManager textContainerChangedGeometry:self];
}

- (NSArray*)exclusionPaths {
    return _exclusionPaths;
}

/**
 @Status Caveat

 @Notes reaminingRect parameter is not supported
*/

- (CGRect)lineFragmentRectForProposedRect:(CGRect)proposed
                                  atIndex:(NSUInteger)idx
                         writingDirection:(NSWritingDirection)direction
                            remainingRect:(CGRect*)remainingRect {
    CGRect totalRect = CGRectMake(0, 0, _size.width, _size.height);
    CGRect ret = CGRectIntersection(proposed, totalRect);

    if (_exclusionPaths != nil) {
        for (UIBezierPath* path in(NSArray*)_exclusionPaths) {
            CGRect shapeRect = _CGPathFitRect(path.CGPath, ret, _size, self.lineFragmentPadding);
            ret = CGRectIntersection(shapeRect, ret);
        }
    }

    return ret;
}
@end
