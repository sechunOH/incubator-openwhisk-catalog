#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# use the command line interface to install Watson package.
#
SCRIPTDIR="$(cd $(dirname "$0")/ && pwd)"
PACKAGE_HOME=$SCRIPTDIR
source "$PACKAGE_HOME/util.sh"

echo Installing Watson package.


createPackage watson-speechToText \
    -a description "Actions for the Watson analytics APIs to convert speech into text" \
    -a parameters '[ {"name":"bluemixServiceName", "required":false, "bindTime":true}, {"name":"username", "required":false}, {"name":"password", "required":false, "type":"password"} ]' \
	  -a tags '["watson"]' \
	  -p bluemixServiceName 'speech_to_text'

createPackage watson-textToSpeech \
    -a description "Actions for the Watson analytics APIs to convert text into speech" \
    -a parameters '[ {"name":"bluemixServiceName", "required":false, "bindTime":true}, {"name":"username", "required":false}, {"name":"password", "required":false, "type":"password"} ]' \
	  -a tags '["watson"]' \
	  -p bluemixServiceName 'text_to_speech'

waitForAll

install "$PACKAGE_HOME/watson-speechToText/speechToText.js" \
    watson-speechToText/speechToText \
    -a description 'Convert speech to text' \
    -a parameters '[
  {
    "name": "content_type",
    "required": true,
    "description": "The MIME type of the audio"
  },
  {
    "name": "model",
    "required": false,
    "description": "The identifier of the model to be used for the recognition request"
  },
  {
    "name": "continuous",
    "required": false,
    "description": "Indicates whether multiple final results that represent consecutive phrases separated by long pauses are returned"
  },
  {
    "name": "inactivity_timeout",
    "required": false,
    "description": "The time in seconds after which, if only silence (no speech) is detected in submitted audio, the connection is closed"
  },
  {
    "name": "interim_results",
    "required": false,
    "description": "Indicates whether the service is to return interim results"
  },
  {
    "name": "keywords",
    "required": false,
    "description": "A list of keywords to spot in the audio"
  },
  {
    "name": "keywords_threshold",
    "required": false,
    "description": "A confidence value that is the lower bound for spotting a keyword"
  },
  {
    "name": "max_alternatives",
    "required": false,
    "description": "The maximum number of alternative transcripts to be returned"
  },
  {
    "name": "word_alternatives_threshold",
    "required": false,
    "description": "A confidence value that is the lower bound for identifying a hypothesis as a possible word alternative"
  },
  {
    "name": "word_confidence",
    "required": false,
    "description": "Indicates whether a confidence measure in the range of 0 to 1 is to be returned for each word"
  },
  {
    "name": "timestamps",
    "required": false,
    "description": "Indicates whether time alignment is returned for each word"
  },
  {
    "name": "X-Watson-Learning-Opt-Out",
    "required": false,
    "description": "Indicates whether to opt out of data collection for the call"
  },
  {
    "name": "watson-token",
    "required": false,
    "description": "Provides an authentication token for the service as an alternative to providing service credentials"
  },
  {
    "name": "encoding",
    "required": true,
    "description": "The encoding of the speech binary data"
  },
  {
    "name": "payload",
    "required": true,
    "description": "The encoding of the speech binary data"
  },
  {
    "name": "username",
    "required": true,
    "bindTime": true,
    "description": "The Watson service username"
  },
  {
    "name": "password",
    "required": true,
    "type": "password",
    "bindTime": true,
    "description": "The Watson service password"
  }
]' \
    -a sampleInput '{"payload":"<base64 encoding of a wav file>", "encoding":"base64", "content_type":"audio/wav", "username":"XXX", "password":"XXX"}' \
    -a sampleOutput '{"data":"Hello."}'


install "$PACKAGE_HOME/watson-textToSpeech/textToSpeech.js" \
    watson-textToSpeech/textToSpeech \
    -a description 'Synthesize text to spoken audio' \
    -a parameters '[
        {"name":"username", "required":true, "bindTime":true, "description":"The Watson service username"},
        {"name":"password", "required":true, "type":"password", "bindTime":true, "description":"The Watson service password"},
        {"name":"payload", "required":true, "description":"The text to be synthesized"},
        {"name":"voice", "required":false, "description":"The voice to be used for synthesis"},
        {"name":"accept", "required":false, "description":"The requested MIME type of the audio"},
        {"name":"encoding", "required":false, "description":"The encoding of the speech binary data"}]' \
    -a sampleInput '{"payload":"Hello, world.", "encoding":"base64", "accept":"audio/wav", "voice":"en-US_MichaelVoice", "username":"XXX", "password":"XXX" }' \
    -a sampleOutput '{"payload":"<base64 encoding of a .wav file>", "encoding":"base64", "mimetype":"audio/wav"}'

waitForAll

echo Watson package ERRORS = $ERRORS
exit $ERRORS
