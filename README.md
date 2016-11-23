<img src="https://github.com/nemesit/RunSwiftScriptAction/blob/master/Run%20Swift%20Script/SwiftScript.icns?raw=true" width="200">

# RunSwiftScriptAction
An Automator action that lets people run Swift code instead of AppleScript or JavaScript for Automation.

The Action can access it's input from other Automator actions by accessing the `input` optional which is of type `Optional(Array<String>)`
Anything it outputs to standard output e.g. via `print(_:)` gets passed back to Automator and can be used as input for other Actions.




<br><br><br><br><br><br><br><br><br><br>
MIT License

Copyright (c) 2016 Felix Grabowski

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
