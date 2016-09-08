//******************************************************************************
//
// Copyright (c) 2016 Microsoft Corporation. All rights reserved.
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
#pragma once

#include <COMIncludes.h>
#import <DWrite.h>
#import <wrl/client.h>
#include <COMIncludes_End.h>

#import <Foundation/NSObject.h>
#import <vector>

#define NSMakeRangeFromCF(cfr) NSMakeRange(cfr.location == kCFNotFound ? NSNotFound : cfr.location, cfr.length)

// Based off DWRITE_GLYPH_RUN structure
struct _DWriteGlyphRun {
    uint32_t _glyphCount;
    std::vector<uint16_t> _glyphIndices;
    std::vector<CGSize> _glyphAdvances;
};

// Based off DWRITE_GLYPH_RUN_DESCRIPTION structure
struct _DWriteGlyphRunDescription {
    uint32_t _stringLength;
    uint32_t _textPosition;
};

struct _DWriteGlyphRunDetails {
    std::vector<float> _baselineOriginX;
    std::vector<float> _baselineOriginY;
    std::vector<_DWriteGlyphRun> _glyphRuns;
    std::vector<_DWriteGlyphRunDescription> _glyphRunDescriptions;
};

NSArray<NSString*>* _DWriteGetFamilyNames();
NSArray<_CTLine*>* _DWriteGetLines(_CTTypesetter* ts, CFRange range, CGRect frameSize);