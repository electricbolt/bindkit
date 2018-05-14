Pod::Spec.new do |s|
  s.name         = "BindKit"
  s.version      = "1.0.0"
  s.summary      = "Two-way data binding framework for iOS."
  s.description  = "Two-way data binding framework for iOS (static library) supporting i386, x86_64, armv7s, armv7, arm64 and bitcode."
  s.homepage     = "https://github.com/electricbolt/bindkit"
  s.license	     = {
      :type => 'Copyright',
      :text => <<-LICENCETEXT
      BSD 2-Clause License

      Copyright © 2018 Electric Bolt Limited
      All rights reserved.

      Redistribution and use in source and binary forms, with or without
      modification, are permitted provided that the following conditions are met:

      * Redistributions of source code must retain the above copyright notice, this
        list of conditions and the following disclaimer.

      * Redistributions in binary form must reproduce the above copyright notice,
        this list of conditions and the following disclaimer in the documentation
        and/or other materials provided with the distribution.

      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
      AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
      DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
      FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
      DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
      SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
      CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
      OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
      OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
      LICENCETEXT
  }

  s.author       = { 'Electric Bolt Limited' => 'support@electricbolt.co.nz' }
  s.source       = { :git => "https://github.com/electricbolt/BindKit.git", :tag => '1.0.0' }

  s.platform     = :ios, '8.0'
  s.source_files = 'release/*.h'
  s.vendored_libraries = 'release/*.a'
  
end
