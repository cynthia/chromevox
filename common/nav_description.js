// Copyright 2011 Google Inc.
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

cvoxgoog.provide('cvox.NavDescription');

cvoxgoog.require('cvox.AbstractTts');
cvoxgoog.require('cvox.ChromeVox');

/**
 * @fileoverview A simple container object for the description of a
 * navigation from one object to another.
 *
 * @author dmazzoni@google.com (Dominic Mazzoni)
 */

/**
 * A class representing the description of navigation from one object
 * to another.
 * @param {string} context The context, for example descriptions of objects
 *     that were crossed into, like "Toolbar" or "Menu Bar" or "List with
 *     5 items". This is all spoken with an annotation voice.
 * @param {string} text The text of the object itself, including text from
 *     titles, labels, etc.
 * @param {string} userValue The text that the user has entered.
 * @param {string} annotation The role and state of the object.
 * @constructor
 */
cvox.NavDescription = function(context, text, userValue, annotation) {
  this.context = context ? context : '';
  this.text = text ? text : '';
  this.userValue = userValue ? userValue : '';
  this.annotation = annotation ? annotation : '';
};


/**
 * @return {boolean} true if this description is empty.
 */
cvox.NavDescription.prototype.isEmpty = function() {
  return (this.context.length == 0 &&
          this.text.length == 0 &&
          this.userValue.length == 0 &&
          this.annotation.length == 0);
};


/**
 * @return {string} A string representation of this object.
 */
cvox.NavDescription.prototype.toString = function() {
  return 'NavDescription(context="' + this.context + '" ' +
         ' text="' + this.text + '" ' +
         ' userValue="' + this.userValue + '" ' +
         ' annotation="' + this.annotation + '")';
};


/**
 * Speak this nav description with the given queue mode.
 * @param {number=} queueMode The queue mode: cvox.AbstractTts.QUEUE_MODE_FLUSH
 *     for flush, cvox.AbstractTts.QUEUE_MODE_QUEUE for adding to queue.
 * @param {function()=} callBack The callback function.
 */
cvox.NavDescription.prototype.speak = function(queueMode, callBack) {
  var speakArgs = new Array();
  if (this.context) {
    speakArgs.push([this.context, queueMode,
      cvox.AbstractTts.PERSONALITY_ANNOTATION]);
    queueMode = 1;
  }
  if (this.text) {
    speakArgs.push([this.text, queueMode, null]);
    queueMode = 1;
  }
  if (this.userValue) {
    cvox.ChromeVox.tts.speak(this.userValue, queueMode, null);
    queueMode = 1;
  }
  if (this.annotation) {
    speakArgs.push([this.annotation, queueMode,
      cvox.AbstractTts.PERSONALITY_ANNOTATION]);
  }

  var length = speakArgs.length;
  for (var i = 0; i < length; i++) {
    if (i == length - 1) {
      speakArgs[i].push(callBack);
    }
    cvox.ChromeVox.tts.speak.apply(cvox.ChromeVox.tts, speakArgs[i]);
  }
};
