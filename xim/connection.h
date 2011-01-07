/*

  Copyright (c) 2003-2011 uim Project http://code.google.com/p/uim/

  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:

  1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
  3. Neither the name of authors nor the names of its contributors
     may be used to endorse or promote products derived from this software
     without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  SUCH DAMAGE.
*/

#ifndef UIM_XIM_CONNECTION_H
#define UIM_XIM_CONNECTION_H

#include "xim.h"
#include "xdispatch.h"

int connection_setup();

class XConnection: public Connection, public WindowIf {
public:
    XConnection(XimServer *svr, Window clientWin, Window commWin);
    virtual ~XConnection();
    virtual void expose(Window) {};
    virtual void destroy(Window);

    void readProc(XClientMessageEvent *);
    void writeProc();
    void writePendingPacket();
    void writePassivePacket();
    void writeNormalPacket();
    bool isValid() {return mIsValid;};
private:
    bool readToBuf(XClientMessageEvent *);
    bool checkByteorder();
    void shiftBuffer(int);
    void doSend(TxPacket *t, bool is_passive);

    Window mClientWin, mCommWin;
    bool mIsValid;
    struct {
	char *buf;
	int len;
	long size;
    } mBuf;
};

#endif
