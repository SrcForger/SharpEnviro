/*

Copyright (c) 2010 Brook Miles

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

#include "stdafx.h"

void Split(const tstring& str, std::vector<tstring>& out, TCHAR sep, bool includeEmpty)
{
	unsigned start = 0;
	unsigned end = 0;

	while(true)
	{
		if(end == str.size() || str[end] == sep)
		{
			if(end > start || includeEmpty)
			{
				out.push_back(str.substr(start, end - start));
			}

			if(end == str.size())
			{
				break;
			}

			++end;
			start = end;
		}
		else
		{
			++end;
		}
	}
}

tstring GetWord(const tstring& str, unsigned index, bool getRest)
{
	unsigned start = 0;
	unsigned end = 0;

	unsigned count = 0;

	while(true)
	{
		if(end == str.size() || str[end] == _T(' '))
		{
			if(end > start)
			{
				if(count == index)
				{
					if(getRest)
					{
						return str.substr(start);
					}
					else
					{
						return str.substr(start, end - start);
					}
				}
				++count;
			}

			if(end == str.size())
			{
				break;
			}

			++end;
			start = end;
		}
		else
		{
			++end;
		}
	}
	return _T("");
}
