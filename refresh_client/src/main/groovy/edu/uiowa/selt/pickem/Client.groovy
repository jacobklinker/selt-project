/*
 * Copyright (C) 2015 Jacob Klinker
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package edu.uiowa.selt.pickem

public class Client {
    
    static final String URL = "https://glacial-reef-4224.herokuapp.com"

    public static void main(String[] args) {
        Timer timer = new Timer()

        // execute syncing games and spreads every 4 hours
        timer.schedule(new SyncClient(), 0, 1000 * 60 * 60 * 4)

        // execute syncing scores from twitter every 15 minutes
        timer.schedule(new ScoreSyncClient(), 0, 1000 * 60 * 15)
    }
}