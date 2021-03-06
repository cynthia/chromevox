// Copyright 2012 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * @preserve
 * @filename walkers/word_walker.js
 */

/**
 * @fileoverview A class for walking one word at a time.
 * @author stoarca@google.com (Sergiu Toarca)
 */


goog.provide('cvox.WordWalker');

goog.require('cvox.AbstractSelectionWalker');
goog.require('cvox.TraverseContent');

/**
 * @constructor
 * @extends {cvox.AbstractSelectionWalker}
 */
cvox.WordWalker = function() {
  cvox.AbstractSelectionWalker.call(this);
  this.grain = cvox.TraverseContent.kWord;
};
goog.inherits(cvox.WordWalker, cvox.AbstractSelectionWalker);

/**
 * @override
 */
cvox.WordWalker.prototype.getGranularityMsg = function() {
  return cvox.ChromeVox.msgs.getMsg('word_granularity');
};
