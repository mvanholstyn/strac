#line 1 "ext/hpricot_scan/hpricot_scan.rl"
/*
 * hpricot_scan.rl
 *
 * $Author: why $
 * $Date: 2006-05-08 22:03:50 -0600 (Mon, 08 May 2006) $
 *
 * Copyright (C) 2006 why the lucky stiff
 */
#include <ruby.h>

#define NO_WAY_SERIOUSLY "*** This should not happen, please send a bug report with the HTML you're parsing to why@whytheluckystiff.net.  So sorry!"

static VALUE sym_xmldecl, sym_doctype, sym_procins, sym_stag, sym_etag, sym_emptytag, sym_comment,
      sym_cdata, sym_text;
static VALUE rb_eHpricotParseError;
static ID s_read, s_to_str;

#define ELE(N) \
  if (tokend > tokstart || text == 1) { \
    VALUE raw_string = Qnil; \
    ele_open = 0; text = 0; \
    if (tokstart != 0 && sym_##N != sym_cdata && sym_##N != sym_text && sym_##N != sym_procins && sym_##N != sym_comment) { \
      raw_string = rb_str_new(tokstart, tokend-tokstart); \
    } \
    rb_yield_tokens(sym_##N, tag, attr, raw_string, taint); \
  }

#define SET(N, E) \
  if (mark_##N == NULL || E == mark_##N) \
    N = rb_str_new2(""); \
  else if (E > mark_##N) \
    N = rb_str_new(mark_##N, E - mark_##N);

#define CAT(N, E) if (NIL_P(N)) { SET(N, E); } else { rb_str_cat(N, mark_##N, E - mark_##N); }

#define SLIDE(N) if ( mark_##N > tokstart ) mark_##N = buf + (mark_##N - tokstart);

#define ATTR(K, V) \
    if (!NIL_P(K)) { \
      if (NIL_P(attr)) attr = rb_hash_new(); \
      rb_hash_aset(attr, K, V); \
    }

#define TEXT_PASS() \
    if (text == 0) \
    { \
      if (ele_open == 1) { \
        ele_open = 0; \
        if (tokstart > 0) { \
          mark_tag = tokstart; \
        } \
      } else { \
        mark_tag = p; \
      } \
      attr = Qnil; \
      tag = Qnil; \
      text = 1; \
    }

#define EBLK(N, T) CAT(tag, p - T + 1); ELE(N);

#line 174 "ext/hpricot_scan/hpricot_scan.rl"



#line 68 "ext/hpricot_scan/hpricot_scan.c"
static const int hpricot_scan_start = 198;

static const int hpricot_scan_error = -1;

#line 177 "ext/hpricot_scan/hpricot_scan.rl"

#define BUFSIZE 16384

void rb_yield_tokens(VALUE sym, VALUE tag, VALUE attr, VALUE raw, int taint)
{
  VALUE ary;
  if (sym == sym_text) {
    raw = tag;
  }
  ary = rb_ary_new3(4, sym, tag, attr, raw);
  if (taint) { 
    OBJ_TAINT(ary);
    OBJ_TAINT(tag);
    OBJ_TAINT(attr);
    OBJ_TAINT(raw);
  }
  rb_yield(ary);
}

VALUE hpricot_scan(VALUE self, VALUE port)
{
  int cs, act, have = 0, nread = 0, curline = 1, text = 0;
  char *tokstart = 0, *tokend = 0, *buf = NULL;

  VALUE attr = Qnil, tag = Qnil, akey = Qnil, aval = Qnil, bufsize = Qnil;
  char *mark_tag = 0, *mark_akey = 0, *mark_aval = 0;
  int done = 0, ele_open = 0, buffer_size = 0;

  int taint = OBJ_TAINTED( port );
  if ( !rb_respond_to( port, s_read ) )
  {
    if ( rb_respond_to( port, s_to_str ) )
    {
      port = rb_funcall( port, s_to_str, 0 );
      StringValue(port);
    }
    else
    {
      rb_raise( rb_eArgError, "bad argument, String or IO only please." );
    }
  }

  buffer_size = BUFSIZE;
  if (rb_ivar_defined(self, rb_intern("@buffer_size")) == Qtrue) {
    bufsize = rb_ivar_get(self, rb_intern("@buffer_size"));
    if (!NIL_P(bufsize)) {
      buffer_size = NUM2INT(bufsize);
    }
  }
  buf = ALLOC_N(char, buffer_size);

  
#line 126 "ext/hpricot_scan/hpricot_scan.c"
	{
	cs = hpricot_scan_start;
	tokstart = 0;
	tokend = 0;
	act = 0;
	}
#line 229 "ext/hpricot_scan/hpricot_scan.rl"
  
  while ( !done ) {
    VALUE str;
    char *p = buf + have, *pe;
    int len, space = buffer_size - have;

    if ( space == 0 ) {
      /* We've used up the entire buffer storing an already-parsed token
       * prefix that must be preserved.  Likely caused by super-long attributes.
       * See ticket #13. */
      rb_raise(rb_eHpricotParseError, "ran out of buffer space on element <%s>, starting on line %d.", RSTRING(tag)->ptr, curline);
    }

    if ( rb_respond_to( port, s_read ) )
    {
      str = rb_funcall( port, s_read, 1, INT2FIX(space) );
    }
    else
    {
      str = rb_str_substr( port, nread, space );
    }

    StringValue(str);
    memcpy( p, RSTRING(str)->ptr, RSTRING(str)->len );
    len = RSTRING(str)->len;
    nread += len;

    /* If this is the last buffer, tack on an EOF. */
    if ( len < space ) {
      p[len++] = 0;
      done = 1;
    }

    pe = p + len;
    
#line 169 "ext/hpricot_scan/hpricot_scan.c"
	{
	if ( p == pe )
		goto _out;
	switch ( cs )
	{
tr11:
#line 166 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p;{ {{p = ((tokend))-1;}{goto st212;}} }{p = ((tokend))-1;}}
	goto st198;
tr15:
#line 172 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st198;
tr20:
#line 172 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st198;
tr21:
#line 109 "ext/hpricot_scan/hpricot_scan.rl"
	{curline += 1;}
#line 172 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st198;
tr62:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{	switch( act ) {
	case 8:
	{ ELE(doctype); }
	break;
	case 10:
	{ ELE(stag); }
	break;
	case 12:
	{ ELE(emptytag); }
	break;
	case 15:
	{ TEXT_PASS(); }
	break;
	default: break;
	}
	{p = ((tokend))-1;}}
	goto st198;
tr63:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(stag); }{p = ((tokend))-1;}}
	goto st198;
tr69:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(stag); }{p = ((tokend))-1;}}
	goto st198;
tr117:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(stag); }{p = ((tokend))-1;}}
	goto st198;
tr142:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(stag); }{p = ((tokend))-1;}}
	goto st198;
tr238:
#line 166 "ext/hpricot_scan/hpricot_scan.rl"
	{{ {{p = ((tokend))-1;}{goto st212;}} }{p = ((tokend))-1;}}
	goto st198;
tr269:
#line 164 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(xmldecl); }{p = ((tokend))-1;}}
	goto st198;
tr270:
#line 172 "ext/hpricot_scan/hpricot_scan.rl"
	{{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st198;
tr276:
#line 165 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(doctype); }{p = ((tokend))-1;}}
	goto st198;
tr288:
#line 168 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(etag); }{p = ((tokend))-1;}}
	goto st198;
tr292:
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(stag); }{p = ((tokend))-1;}}
	goto st198;
tr301:
#line 80 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(tag, p); }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(stag); }{p = ((tokend))-1;}}
	goto st198;
tr304:
#line 80 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(tag, p); }
#line 165 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(doctype); }{p = ((tokend))-1;}}
	goto st198;
tr308:
#line 80 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(tag, p); }
#line 168 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(etag); }{p = ((tokend))-1;}}
	goto st198;
tr329:
#line 171 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ {{p = ((tokend))-1;}{goto st210;}} }{p = ((tokend))-1;}}
	goto st198;
tr330:
#line 170 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ {{p = ((tokend))-1;}{goto st208;}} }{p = ((tokend))-1;}}
	goto st198;
tr342:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(stag); }{p = ((tokend))-1;}}
	goto st198;
tr343:
#line 169 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ ELE(emptytag); }{p = ((tokend))-1;}}
	goto st198;
st198:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokstart = 0;}
	if ( ++p == pe )
		goto _out198;
case 198:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokstart = p;}
#line 333 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 10: goto tr21;
		case 60: goto tr22;
	}
	goto tr20;
tr22:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 65 "ext/hpricot_scan/hpricot_scan.rl"
	{
    if (text == 1) {
      CAT(tag, p);
      ELE(text);
      text = 0;
    }
    attr = Qnil;
    tag = Qnil;
    mark_tag = NULL;
    ele_open = 1;
  }
#line 172 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 15;}
	goto st199;
st199:
	if ( ++p == pe )
		goto _out199;
case 199:
#line 361 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 33: goto st0;
		case 47: goto st59;
		case 58: goto tr18;
		case 63: goto st139;
		case 95: goto tr18;
	}
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr18;
	} else if ( (*p) >= 65 )
		goto tr18;
	goto tr15;
st0:
	if ( ++p == pe )
		goto _out0;
case 0:
	switch( (*p) ) {
		case 45: goto st1;
		case 68: goto st2;
		case 91: goto st53;
	}
	goto tr270;
st1:
	if ( ++p == pe )
		goto _out1;
case 1:
	if ( (*p) == 45 )
		goto tr330;
	goto tr270;
st2:
	if ( ++p == pe )
		goto _out2;
case 2:
	if ( (*p) == 79 )
		goto st3;
	goto tr270;
st3:
	if ( ++p == pe )
		goto _out3;
case 3:
	if ( (*p) == 67 )
		goto st4;
	goto tr270;
st4:
	if ( ++p == pe )
		goto _out4;
case 4:
	if ( (*p) == 84 )
		goto st5;
	goto tr270;
st5:
	if ( ++p == pe )
		goto _out5;
case 5:
	if ( (*p) == 89 )
		goto st6;
	goto tr270;
st6:
	if ( ++p == pe )
		goto _out6;
case 6:
	if ( (*p) == 80 )
		goto st7;
	goto tr270;
st7:
	if ( ++p == pe )
		goto _out7;
case 7:
	if ( (*p) == 69 )
		goto st8;
	goto tr270;
st8:
	if ( ++p == pe )
		goto _out8;
case 8:
	if ( (*p) == 32 )
		goto st9;
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st9;
	goto tr270;
st9:
	if ( ++p == pe )
		goto _out9;
case 9:
	switch( (*p) ) {
		case 32: goto st9;
		case 58: goto tr283;
		case 95: goto tr283;
	}
	if ( (*p) < 65 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st9;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr283;
	} else
		goto tr283;
	goto tr270;
tr283:
#line 77 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_tag = p; }
	goto st10;
st10:
	if ( ++p == pe )
		goto _out10;
case 10:
#line 469 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr302;
		case 62: goto tr304;
		case 63: goto st10;
		case 91: goto tr305;
		case 95: goto st10;
	}
	if ( (*p) < 48 ) {
		if ( (*p) > 13 ) {
			if ( 45 <= (*p) && (*p) <= 46 )
				goto st10;
		} else if ( (*p) >= 9 )
			goto tr302;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st10;
		} else if ( (*p) >= 65 )
			goto st10;
	} else
		goto st10;
	goto tr270;
tr302:
#line 80 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(tag, p); }
	goto st11;
st11:
	if ( ++p == pe )
		goto _out11;
case 11:
#line 500 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st11;
		case 62: goto tr276;
		case 80: goto st12;
		case 83: goto st48;
		case 91: goto st26;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st11;
	goto tr270;
st12:
	if ( ++p == pe )
		goto _out12;
case 12:
	if ( (*p) == 85 )
		goto st13;
	goto tr270;
st13:
	if ( ++p == pe )
		goto _out13;
case 13:
	if ( (*p) == 66 )
		goto st14;
	goto tr270;
st14:
	if ( ++p == pe )
		goto _out14;
case 14:
	if ( (*p) == 76 )
		goto st15;
	goto tr270;
st15:
	if ( ++p == pe )
		goto _out15;
case 15:
	if ( (*p) == 73 )
		goto st16;
	goto tr270;
st16:
	if ( ++p == pe )
		goto _out16;
case 16:
	if ( (*p) == 67 )
		goto st17;
	goto tr270;
st17:
	if ( ++p == pe )
		goto _out17;
case 17:
	if ( (*p) == 32 )
		goto st18;
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st18;
	goto tr270;
st18:
	if ( ++p == pe )
		goto _out18;
case 18:
	switch( (*p) ) {
		case 32: goto st18;
		case 34: goto st19;
		case 39: goto st30;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st18;
	goto tr270;
st19:
	if ( ++p == pe )
		goto _out19;
case 19:
	switch( (*p) ) {
		case 9: goto tr295;
		case 34: goto tr294;
		case 61: goto tr295;
		case 95: goto tr295;
	}
	if ( (*p) < 39 ) {
		if ( 32 <= (*p) && (*p) <= 37 )
			goto tr295;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr295;
		} else if ( (*p) >= 63 )
			goto tr295;
	} else
		goto tr295;
	goto tr270;
tr295:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st20;
st20:
	if ( ++p == pe )
		goto _out20;
case 20:
#line 597 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 9: goto st20;
		case 34: goto tr294;
		case 61: goto st20;
		case 95: goto st20;
	}
	if ( (*p) < 39 ) {
		if ( 32 <= (*p) && (*p) <= 37 )
			goto st20;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st20;
		} else if ( (*p) >= 63 )
			goto st20;
	} else
		goto st20;
	goto tr270;
tr294:
#line 91 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("public_id"), aval); }
	goto st21;
st21:
	if ( ++p == pe )
		goto _out21;
case 21:
#line 624 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st22;
		case 62: goto tr276;
		case 91: goto st26;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st22;
	goto tr270;
st22:
	if ( ++p == pe )
		goto _out22;
case 22:
	switch( (*p) ) {
		case 32: goto st22;
		case 34: goto st23;
		case 39: goto st28;
		case 62: goto tr276;
		case 91: goto st26;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st22;
	goto tr270;
st23:
	if ( ++p == pe )
		goto _out23;
case 23:
	if ( (*p) == 34 )
		goto tr5;
	goto tr196;
tr196:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st24;
st24:
	if ( ++p == pe )
		goto _out24;
case 24:
#line 662 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 34 )
		goto tr5;
	goto st24;
tr5:
#line 92 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("system_id"), aval); }
	goto st25;
st25:
	if ( ++p == pe )
		goto _out25;
case 25:
#line 674 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st25;
		case 62: goto tr276;
		case 91: goto st26;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st25;
	goto tr62;
tr305:
#line 80 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(tag, p); }
	goto st26;
st26:
	if ( ++p == pe )
		goto _out26;
case 26:
#line 691 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 93 )
		goto st27;
	goto st26;
st27:
	if ( ++p == pe )
		goto _out27;
case 27:
	switch( (*p) ) {
		case 32: goto st27;
		case 62: goto tr276;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st27;
	goto tr62;
st28:
	if ( ++p == pe )
		goto _out28;
case 28:
	if ( (*p) == 39 )
		goto tr5;
	goto tr160;
tr160:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st29;
st29:
	if ( ++p == pe )
		goto _out29;
case 29:
#line 721 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 39 )
		goto tr5;
	goto st29;
st30:
	if ( ++p == pe )
		goto _out30;
case 30:
	switch( (*p) ) {
		case 9: goto tr296;
		case 39: goto tr297;
		case 61: goto tr296;
		case 95: goto tr296;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 33 ) {
			if ( 35 <= (*p) && (*p) <= 37 )
				goto tr296;
		} else if ( (*p) >= 32 )
			goto tr296;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr296;
		} else if ( (*p) >= 63 )
			goto tr296;
	} else
		goto tr296;
	goto tr270;
tr296:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st31;
st31:
	if ( ++p == pe )
		goto _out31;
case 31:
#line 758 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 9: goto st31;
		case 39: goto tr277;
		case 61: goto st31;
		case 95: goto st31;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 33 ) {
			if ( 35 <= (*p) && (*p) <= 37 )
				goto st31;
		} else if ( (*p) >= 32 )
			goto st31;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st31;
		} else if ( (*p) >= 63 )
			goto st31;
	} else
		goto st31;
	goto tr270;
tr38:
#line 91 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("public_id"), aval); }
#line 92 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("system_id"), aval); }
	goto st32;
tr277:
#line 91 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("public_id"), aval); }
	goto st32;
tr297:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 91 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("public_id"), aval); }
	goto st32;
st32:
	if ( ++p == pe )
		goto _out32;
case 32:
#line 800 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 9: goto st33;
		case 32: goto st33;
		case 33: goto st31;
		case 39: goto tr277;
		case 62: goto tr276;
		case 91: goto st26;
		case 95: goto st31;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 13 ) {
			if ( 35 <= (*p) && (*p) <= 37 )
				goto st31;
		} else if ( (*p) >= 10 )
			goto st22;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st31;
		} else if ( (*p) >= 61 )
			goto st31;
	} else
		goto st31;
	goto tr270;
st33:
	if ( ++p == pe )
		goto _out33;
case 33:
	switch( (*p) ) {
		case 9: goto st33;
		case 32: goto st33;
		case 34: goto st23;
		case 39: goto tr275;
		case 62: goto tr276;
		case 91: goto st26;
		case 95: goto st31;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 13 ) {
			if ( 33 <= (*p) && (*p) <= 37 )
				goto st31;
		} else if ( (*p) >= 10 )
			goto st22;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st31;
		} else if ( (*p) >= 61 )
			goto st31;
	} else
		goto st31;
	goto tr270;
tr40:
#line 91 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("public_id"), aval); }
#line 92 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("system_id"), aval); }
	goto st34;
tr275:
#line 91 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("public_id"), aval); }
	goto st34;
st34:
	if ( ++p == pe )
		goto _out34;
case 34:
#line 867 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 9: goto tr164;
		case 32: goto tr164;
		case 33: goto tr166;
		case 39: goto tr38;
		case 62: goto tr162;
		case 91: goto tr163;
		case 95: goto tr166;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 13 ) {
			if ( 35 <= (*p) && (*p) <= 37 )
				goto tr166;
		} else if ( (*p) >= 10 )
			goto tr165;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr166;
		} else if ( (*p) >= 61 )
			goto tr166;
	} else
		goto tr166;
	goto tr160;
tr164:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st35;
st35:
	if ( ++p == pe )
		goto _out35;
case 35:
#line 900 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 9: goto st35;
		case 32: goto st35;
		case 34: goto st37;
		case 39: goto tr40;
		case 62: goto tr36;
		case 91: goto st40;
		case 95: goto st47;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 13 ) {
			if ( 33 <= (*p) && (*p) <= 37 )
				goto st47;
		} else if ( (*p) >= 10 )
			goto st36;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st47;
		} else if ( (*p) >= 61 )
			goto st47;
	} else
		goto st47;
	goto st29;
tr165:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st36;
st36:
	if ( ++p == pe )
		goto _out36;
case 36:
#line 933 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st36;
		case 34: goto st37;
		case 39: goto tr35;
		case 62: goto tr36;
		case 91: goto st40;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st36;
	goto st29;
st37:
	if ( ++p == pe )
		goto _out37;
case 37:
	switch( (*p) ) {
		case 34: goto tr56;
		case 39: goto tr198;
	}
	goto tr197;
tr197:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st38;
st38:
	if ( ++p == pe )
		goto _out38;
case 38:
#line 961 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr56;
		case 39: goto tr57;
	}
	goto st38;
tr56:
#line 92 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("system_id"), aval); }
	goto st39;
tr161:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st39;
st39:
	if ( ++p == pe )
		goto _out39;
case 39:
#line 979 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st39;
		case 39: goto tr5;
		case 62: goto tr36;
		case 91: goto st40;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st39;
	goto st29;
tr36:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 165 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 8;}
	goto st200;
tr162:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 165 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 8;}
	goto st200;
st200:
	if ( ++p == pe )
		goto _out200;
case 200:
#line 1007 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 39 )
		goto tr5;
	goto st29;
tr163:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st40;
st40:
	if ( ++p == pe )
		goto _out40;
case 40:
#line 1019 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 39: goto tr31;
		case 93: goto st42;
	}
	goto st40;
tr31:
#line 92 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("system_id"), aval); }
	goto st41;
st41:
	if ( ++p == pe )
		goto _out41;
case 41:
#line 1033 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st41;
		case 62: goto tr24;
		case 93: goto st27;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st41;
	goto st26;
tr24:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 165 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 8;}
	goto st201;
st201:
	if ( ++p == pe )
		goto _out201;
case 201:
#line 1052 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 93 )
		goto st27;
	goto st26;
st42:
	if ( ++p == pe )
		goto _out42;
case 42:
	switch( (*p) ) {
		case 32: goto st42;
		case 39: goto tr5;
		case 62: goto tr36;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st42;
	goto st29;
tr57:
#line 92 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("system_id"), aval); }
	goto st43;
tr198:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 92 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("system_id"), aval); }
	goto st43;
st43:
	if ( ++p == pe )
		goto _out43;
case 43:
#line 1082 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st43;
		case 34: goto tr5;
		case 62: goto tr54;
		case 91: goto st44;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st43;
	goto st24;
tr54:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 165 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 8;}
	goto st202;
st202:
	if ( ++p == pe )
		goto _out202;
case 202:
#line 1102 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 34 )
		goto tr5;
	goto st24;
st44:
	if ( ++p == pe )
		goto _out44;
case 44:
	switch( (*p) ) {
		case 34: goto tr31;
		case 93: goto st45;
	}
	goto st44;
st45:
	if ( ++p == pe )
		goto _out45;
case 45:
	switch( (*p) ) {
		case 32: goto st45;
		case 34: goto tr5;
		case 62: goto tr54;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st45;
	goto st24;
tr35:
#line 92 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("system_id"), aval); }
	goto st46;
st46:
	if ( ++p == pe )
		goto _out46;
case 46:
#line 1135 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr161;
		case 39: goto tr5;
		case 62: goto tr162;
		case 91: goto tr163;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto tr161;
	goto tr160;
tr166:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st47;
st47:
	if ( ++p == pe )
		goto _out47;
case 47:
#line 1153 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 9: goto st47;
		case 39: goto tr38;
		case 61: goto st47;
		case 95: goto st47;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 33 ) {
			if ( 35 <= (*p) && (*p) <= 37 )
				goto st47;
		} else if ( (*p) >= 32 )
			goto st47;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st47;
		} else if ( (*p) >= 63 )
			goto st47;
	} else
		goto st47;
	goto st29;
st48:
	if ( ++p == pe )
		goto _out48;
case 48:
	if ( (*p) == 89 )
		goto st49;
	goto tr270;
st49:
	if ( ++p == pe )
		goto _out49;
case 49:
	if ( (*p) == 83 )
		goto st50;
	goto tr270;
st50:
	if ( ++p == pe )
		goto _out50;
case 50:
	if ( (*p) == 84 )
		goto st51;
	goto tr270;
st51:
	if ( ++p == pe )
		goto _out51;
case 51:
	if ( (*p) == 69 )
		goto st52;
	goto tr270;
st52:
	if ( ++p == pe )
		goto _out52;
case 52:
	if ( (*p) == 77 )
		goto st21;
	goto tr270;
st53:
	if ( ++p == pe )
		goto _out53;
case 53:
	if ( (*p) == 67 )
		goto st54;
	goto tr270;
st54:
	if ( ++p == pe )
		goto _out54;
case 54:
	if ( (*p) == 68 )
		goto st55;
	goto tr270;
st55:
	if ( ++p == pe )
		goto _out55;
case 55:
	if ( (*p) == 65 )
		goto st56;
	goto tr270;
st56:
	if ( ++p == pe )
		goto _out56;
case 56:
	if ( (*p) == 84 )
		goto st57;
	goto tr270;
st57:
	if ( ++p == pe )
		goto _out57;
case 57:
	if ( (*p) == 65 )
		goto st58;
	goto tr270;
st58:
	if ( ++p == pe )
		goto _out58;
case 58:
	if ( (*p) == 91 )
		goto tr329;
	goto tr270;
st59:
	if ( ++p == pe )
		goto _out59;
case 59:
	switch( (*p) ) {
		case 58: goto tr312;
		case 95: goto tr312;
	}
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr312;
	} else if ( (*p) >= 65 )
		goto tr312;
	goto tr270;
tr312:
#line 77 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_tag = p; }
	goto st60;
st60:
	if ( ++p == pe )
		goto _out60;
case 60:
#line 1274 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr306;
		case 62: goto tr308;
		case 63: goto st60;
		case 95: goto st60;
	}
	if ( (*p) < 48 ) {
		if ( (*p) > 13 ) {
			if ( 45 <= (*p) && (*p) <= 46 )
				goto st60;
		} else if ( (*p) >= 9 )
			goto tr306;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st60;
		} else if ( (*p) >= 65 )
			goto st60;
	} else
		goto st60;
	goto tr270;
tr306:
#line 80 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(tag, p); }
	goto st61;
st61:
	if ( ++p == pe )
		goto _out61;
case 61:
#line 1304 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st61;
		case 62: goto tr288;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st61;
	goto tr270;
tr18:
#line 77 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_tag = p; }
	goto st62;
st62:
	if ( ++p == pe )
		goto _out62;
case 62:
#line 1320 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr298;
		case 47: goto tr300;
		case 62: goto tr301;
		case 63: goto st62;
		case 95: goto st62;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr298;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st62;
		} else if ( (*p) >= 65 )
			goto st62;
	} else
		goto st62;
	goto tr270;
tr298:
#line 80 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(tag, p); }
	goto st63;
st63:
	if ( ++p == pe )
		goto _out63;
case 63:
#line 1348 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st63;
		case 47: goto st66;
		case 62: goto tr292;
		case 63: goto tr290;
		case 95: goto tr290;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st63;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr290;
		} else if ( (*p) >= 65 )
			goto tr290;
	} else
		goto tr290;
	goto tr270;
tr334:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st64;
tr290:
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st64;
st64:
	if ( ++p == pe )
		goto _out64;
case 64:
#line 1398 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr338;
		case 47: goto tr340;
		case 61: goto tr341;
		case 62: goto tr342;
		case 63: goto st64;
		case 95: goto st64;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr338;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st64;
		} else if ( (*p) >= 65 )
			goto st64;
	} else
		goto st64;
	goto tr62;
tr64:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st65;
tr338:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
	goto st65;
tr112:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st65;
st65:
	if ( ++p == pe )
		goto _out65;
case 65:
#line 1443 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st65;
		case 47: goto tr335;
		case 61: goto st67;
		case 62: goto tr142;
		case 63: goto tr334;
		case 95: goto tr334;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st65;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr334;
		} else if ( (*p) >= 65 )
			goto tr334;
	} else
		goto tr334;
	goto tr62;
tr335:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st66;
tr340:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st66;
tr300:
#line 80 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(tag, p); }
	goto st66;
st66:
	if ( ++p == pe )
		goto _out66;
case 66:
#line 1486 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 62 )
		goto tr343;
	goto tr62;
tr341:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
	goto st67;
st67:
	if ( ++p == pe )
		goto _out67;
case 67:
#line 1498 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr137;
		case 34: goto st136;
		case 39: goto st137;
		case 47: goto tr141;
		case 60: goto tr62;
		case 62: goto tr142;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr138;
	} else if ( (*p) >= 9 )
		goto tr137;
	goto tr136;
tr136:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st68;
st68:
	if ( ++p == pe )
		goto _out68;
case 68:
#line 1521 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr59;
		case 47: goto tr61;
		case 60: goto tr62;
		case 62: goto tr63;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr60;
	} else if ( (*p) >= 9 )
		goto tr59;
	goto st68;
tr3:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st69;
tr59:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st69;
st69:
	if ( ++p == pe )
		goto _out69;
case 69:
#line 1549 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st69;
		case 47: goto tr335;
		case 62: goto tr142;
		case 63: goto tr334;
		case 95: goto tr334;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st69;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr334;
		} else if ( (*p) >= 65 )
			goto tr334;
	} else
		goto tr334;
	goto tr62;
tr73:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st70;
tr60:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st70;
st70:
	if ( ++p == pe )
		goto _out70;
case 70:
#line 1584 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr59;
		case 47: goto tr67;
		case 60: goto tr62;
		case 62: goto tr69;
		case 63: goto tr66;
		case 95: goto tr66;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr60;
		} else if ( (*p) >= 9 )
			goto tr59;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr66;
		} else if ( (*p) >= 65 )
			goto tr66;
	} else
		goto tr66;
	goto st68;
tr66:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st71;
tr145:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st71;
st71:
	if ( ++p == pe )
		goto _out71;
case 71:
#line 1644 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr112;
		case 47: goto tr115;
		case 60: goto tr62;
		case 61: goto tr116;
		case 62: goto tr117;
		case 63: goto st71;
		case 95: goto st71;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr113;
		} else if ( (*p) >= 9 )
			goto tr112;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st71;
		} else if ( (*p) >= 65 )
			goto st71;
	} else
		goto st71;
	goto st68;
tr65:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st72;
tr113:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st72;
st72:
	if ( ++p == pe )
		goto _out72;
case 72:
#line 1689 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr64;
		case 47: goto tr67;
		case 60: goto tr62;
		case 61: goto st74;
		case 62: goto tr69;
		case 63: goto tr66;
		case 95: goto tr66;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr65;
		} else if ( (*p) >= 9 )
			goto tr64;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr66;
		} else if ( (*p) >= 65 )
			goto tr66;
	} else
		goto tr66;
	goto st68;
tr61:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st73;
tr67:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st73;
tr115:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st73;
tr141:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st73;
tr204:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st73;
tr205:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st73;
st73:
	if ( ++p == pe )
		goto _out73;
case 73:
#line 1787 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr59;
		case 47: goto tr61;
		case 60: goto tr62;
		case 62: goto tr63;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr60;
	} else if ( (*p) >= 9 )
		goto tr59;
	goto st68;
tr116:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
	goto st74;
tr138:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st74;
st74:
	if ( ++p == pe )
		goto _out74;
case 74:
#line 1812 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr200;
		case 34: goto st77;
		case 39: goto st135;
		case 47: goto tr204;
		case 60: goto tr62;
		case 62: goto tr63;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr201;
	} else if ( (*p) >= 9 )
		goto tr200;
	goto tr136;
tr143:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st75;
tr200:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st75;
st75:
	if ( ++p == pe )
		goto _out75;
case 75:
#line 1844 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr143;
		case 34: goto st136;
		case 39: goto st137;
		case 47: goto tr141;
		case 60: goto tr62;
		case 62: goto tr142;
		case 63: goto tr145;
		case 95: goto tr145;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr144;
		} else if ( (*p) >= 9 )
			goto tr143;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr145;
		} else if ( (*p) >= 65 )
			goto tr145;
	} else
		goto tr145;
	goto tr136;
tr144:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st76;
tr201:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st76;
st76:
	if ( ++p == pe )
		goto _out76;
case 76:
#line 1887 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr200;
		case 34: goto st77;
		case 39: goto st135;
		case 47: goto tr205;
		case 60: goto tr62;
		case 62: goto tr69;
		case 63: goto tr145;
		case 95: goto tr145;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr201;
		} else if ( (*p) >= 9 )
			goto tr200;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr145;
		} else if ( (*p) >= 65 )
			goto tr145;
	} else
		goto tr145;
	goto tr136;
st77:
	if ( ++p == pe )
		goto _out77;
case 77:
	switch( (*p) ) {
		case 32: goto tr222;
		case 34: goto tr73;
		case 47: goto tr220;
		case 60: goto tr176;
		case 62: goto tr224;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr223;
	} else if ( (*p) >= 9 )
		goto tr222;
	goto tr167;
tr167:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st78;
st78:
	if ( ++p == pe )
		goto _out78;
case 78:
#line 1938 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr80;
		case 34: goto tr73;
		case 47: goto tr82;
		case 60: goto st80;
		case 62: goto tr83;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr81;
	} else if ( (*p) >= 9 )
		goto tr80;
	goto st78;
tr9:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st79;
tr80:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st79;
tr177:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st79;
tr191:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st79;
tr222:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st79;
st79:
	if ( ++p == pe )
		goto _out79;
case 79:
#line 1986 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st79;
		case 34: goto tr3;
		case 47: goto tr44;
		case 62: goto tr45;
		case 63: goto tr43;
		case 95: goto tr43;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st79;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr43;
		} else if ( (*p) >= 65 )
			goto tr43;
	} else
		goto tr43;
	goto st80;
tr176:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st80;
st80:
	if ( ++p == pe )
		goto _out80;
case 80:
#line 2015 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 34 )
		goto tr3;
	goto st80;
tr43:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st81;
tr178:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st81;
st81:
	if ( ++p == pe )
		goto _out81;
case 81:
#line 2055 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr102;
		case 34: goto tr3;
		case 47: goto tr104;
		case 61: goto tr105;
		case 62: goto tr106;
		case 63: goto st81;
		case 95: goto st81;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr102;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st81;
		} else if ( (*p) >= 65 )
			goto st81;
	} else
		goto st81;
	goto st80;
tr354:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st82;
tr102:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
	goto st82;
tr124:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st82;
st82:
	if ( ++p == pe )
		goto _out82;
case 82:
#line 2101 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st82;
		case 34: goto tr3;
		case 47: goto tr44;
		case 61: goto st84;
		case 62: goto tr45;
		case 63: goto tr43;
		case 95: goto tr43;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st82;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr43;
		} else if ( (*p) >= 65 )
			goto tr43;
	} else
		goto tr43;
	goto st80;
tr44:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st83;
tr104:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st83;
tr179:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st83;
st83:
	if ( ++p == pe )
		goto _out83;
case 83:
#line 2149 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr3;
		case 62: goto tr41;
	}
	goto st80;
tr41:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 169 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 12;}
	goto st203;
tr45:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st203;
tr83:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st203;
tr86:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st203;
tr106:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st203;
tr129:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st203;
tr180:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st203;
tr224:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st203;
tr225:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st203;
st203:
	if ( ++p == pe )
		goto _out203;
case 203:
#line 2280 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 34 )
		goto tr3;
	goto st80;
tr105:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
	goto st84;
st84:
	if ( ++p == pe )
		goto _out84;
case 84:
#line 2292 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr168;
		case 34: goto tr170;
		case 39: goto st134;
		case 47: goto tr172;
		case 60: goto st80;
		case 62: goto tr45;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr169;
	} else if ( (*p) >= 9 )
		goto tr168;
	goto tr167;
tr168:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st85;
st85:
	if ( ++p == pe )
		goto _out85;
case 85:
#line 2315 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr173;
		case 34: goto tr170;
		case 39: goto st134;
		case 47: goto tr172;
		case 60: goto st80;
		case 62: goto tr45;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr174;
	} else if ( (*p) >= 9 )
		goto tr173;
	goto tr167;
tr173:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st86;
tr216:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st86;
st86:
	if ( ++p == pe )
		goto _out86;
case 86:
#line 2347 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr173;
		case 34: goto tr170;
		case 39: goto st134;
		case 47: goto tr172;
		case 60: goto st80;
		case 62: goto tr45;
		case 63: goto tr175;
		case 95: goto tr175;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr174;
		} else if ( (*p) >= 9 )
			goto tr173;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr175;
		} else if ( (*p) >= 65 )
			goto tr175;
	} else
		goto tr175;
	goto tr167;
tr174:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st87;
tr217:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st87;
st87:
	if ( ++p == pe )
		goto _out87;
case 87:
#line 2390 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr216;
		case 34: goto tr218;
		case 39: goto st94;
		case 47: goto tr221;
		case 60: goto st80;
		case 62: goto tr86;
		case 63: goto tr175;
		case 95: goto tr175;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr217;
		} else if ( (*p) >= 9 )
			goto tr216;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr175;
		} else if ( (*p) >= 65 )
			goto tr175;
	} else
		goto tr175;
	goto tr167;
tr218:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st88;
st88:
	if ( ++p == pe )
		goto _out88;
case 88:
#line 2424 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr222;
		case 34: goto tr73;
		case 47: goto tr221;
		case 60: goto tr176;
		case 62: goto tr225;
		case 63: goto tr175;
		case 95: goto tr175;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr223;
		} else if ( (*p) >= 9 )
			goto tr222;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr175;
		} else if ( (*p) >= 65 )
			goto tr175;
	} else
		goto tr175;
	goto tr167;
tr91:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st89;
tr81:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st89;
tr234:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st89;
tr223:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st89;
st89:
	if ( ++p == pe )
		goto _out89;
case 89:
#line 2479 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr80;
		case 34: goto tr73;
		case 47: goto tr85;
		case 60: goto st80;
		case 62: goto tr86;
		case 63: goto tr84;
		case 95: goto tr84;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr81;
		} else if ( (*p) >= 9 )
			goto tr80;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr84;
		} else if ( (*p) >= 65 )
			goto tr84;
	} else
		goto tr84;
	goto st78;
tr84:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st90;
tr175:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st90;
st90:
	if ( ++p == pe )
		goto _out90;
case 90:
#line 2540 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr124;
		case 34: goto tr73;
		case 47: goto tr127;
		case 60: goto st80;
		case 61: goto tr128;
		case 62: goto tr129;
		case 63: goto st90;
		case 95: goto st90;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr125;
		} else if ( (*p) >= 9 )
			goto tr124;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st90;
		} else if ( (*p) >= 65 )
			goto st90;
	} else
		goto st90;
	goto st78;
tr355:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st91;
tr125:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st91;
st91:
	if ( ++p == pe )
		goto _out91;
case 91:
#line 2586 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr354;
		case 34: goto tr73;
		case 47: goto tr85;
		case 60: goto st80;
		case 61: goto st93;
		case 62: goto tr86;
		case 63: goto tr84;
		case 95: goto tr84;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr355;
		} else if ( (*p) >= 9 )
			goto tr354;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr84;
		} else if ( (*p) >= 65 )
			goto tr84;
	} else
		goto tr84;
	goto st78;
tr82:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st92;
tr85:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st92;
tr127:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st92;
tr172:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st92;
tr220:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st92;
tr221:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st92;
st92:
	if ( ++p == pe )
		goto _out92;
case 92:
#line 2685 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr80;
		case 34: goto tr73;
		case 47: goto tr82;
		case 60: goto st80;
		case 62: goto tr83;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr81;
	} else if ( (*p) >= 9 )
		goto tr80;
	goto st78;
tr128:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
	goto st93;
tr169:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st93;
st93:
	if ( ++p == pe )
		goto _out93;
case 93:
#line 2711 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr216;
		case 34: goto tr218;
		case 39: goto st94;
		case 47: goto tr220;
		case 60: goto st80;
		case 62: goto tr83;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr217;
	} else if ( (*p) >= 9 )
		goto tr216;
	goto tr167;
st94:
	if ( ++p == pe )
		goto _out94;
case 94:
	switch( (*p) ) {
		case 32: goto tr232;
		case 34: goto tr237;
		case 39: goto tr91;
		case 47: goto tr230;
		case 60: goto tr190;
		case 62: goto tr235;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr233;
	} else if ( (*p) >= 9 )
		goto tr232;
	goto tr181;
tr181:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st95;
st95:
	if ( ++p == pe )
		goto _out95;
case 95:
#line 2752 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr88;
		case 34: goto tr90;
		case 39: goto tr91;
		case 47: goto tr92;
		case 60: goto st97;
		case 62: goto tr93;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr89;
	} else if ( (*p) >= 9 )
		goto tr88;
	goto st95;
tr88:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st96;
tr192:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st96;
tr232:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st96;
st96:
	if ( ++p == pe )
		goto _out96;
case 96:
#line 2791 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st96;
		case 34: goto tr8;
		case 39: goto tr9;
		case 47: goto tr49;
		case 62: goto tr50;
		case 63: goto tr48;
		case 95: goto tr48;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st96;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr48;
		} else if ( (*p) >= 65 )
			goto tr48;
	} else
		goto tr48;
	goto st97;
tr190:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st97;
st97:
	if ( ++p == pe )
		goto _out97;
case 97:
#line 2821 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr8;
		case 39: goto tr9;
	}
	goto st97;
tr8:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st98;
tr71:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st98;
tr156:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st98;
tr199:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st98;
tr212:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st98;
st98:
	if ( ++p == pe )
		goto _out98;
case 98:
#line 2861 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st98;
		case 39: goto tr3;
		case 47: goto tr28;
		case 62: goto tr29;
		case 63: goto tr27;
		case 95: goto tr27;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st98;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr27;
		} else if ( (*p) >= 65 )
			goto tr27;
	} else
		goto tr27;
	goto st99;
tr155:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st99;
st99:
	if ( ++p == pe )
		goto _out99;
case 99:
#line 2890 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 39 )
		goto tr3;
	goto st99;
tr27:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st100;
tr157:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st100;
st100:
	if ( ++p == pe )
		goto _out100;
case 100:
#line 2930 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr97;
		case 39: goto tr3;
		case 47: goto tr99;
		case 61: goto tr100;
		case 62: goto tr101;
		case 63: goto st100;
		case 95: goto st100;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr97;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st100;
		} else if ( (*p) >= 65 )
			goto st100;
	} else
		goto st100;
	goto st99;
tr351:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st101;
tr97:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
	goto st101;
tr118:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st101;
st101:
	if ( ++p == pe )
		goto _out101;
case 101:
#line 2976 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st101;
		case 39: goto tr3;
		case 47: goto tr28;
		case 61: goto st103;
		case 62: goto tr29;
		case 63: goto tr27;
		case 95: goto tr27;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st101;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr27;
		} else if ( (*p) >= 65 )
			goto tr27;
	} else
		goto tr27;
	goto st99;
tr28:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st102;
tr99:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st102;
tr158:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st102;
st102:
	if ( ++p == pe )
		goto _out102;
case 102:
#line 3024 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 39: goto tr3;
		case 62: goto tr25;
	}
	goto st99;
tr25:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 169 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 12;}
	goto st204;
tr29:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st204;
tr75:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st204;
tr78:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st204;
tr101:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st204;
tr123:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st204;
tr159:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st204;
tr214:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st204;
tr215:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st204;
st204:
	if ( ++p == pe )
		goto _out204;
case 204:
#line 3155 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 39 )
		goto tr3;
	goto st99;
tr100:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
	goto st103;
st103:
	if ( ++p == pe )
		goto _out103;
case 103:
#line 3167 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr147;
		case 34: goto st130;
		case 39: goto tr150;
		case 47: goto tr151;
		case 60: goto st99;
		case 62: goto tr29;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr148;
	} else if ( (*p) >= 9 )
		goto tr147;
	goto tr146;
tr146:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st104;
st104:
	if ( ++p == pe )
		goto _out104;
case 104:
#line 3190 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr71;
		case 39: goto tr73;
		case 47: goto tr74;
		case 60: goto st99;
		case 62: goto tr75;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr72;
	} else if ( (*p) >= 9 )
		goto tr71;
	goto st104;
tr90:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st105;
tr72:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st105;
tr237:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st105;
tr213:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st105;
st105:
	if ( ++p == pe )
		goto _out105;
case 105:
#line 3234 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr71;
		case 39: goto tr73;
		case 47: goto tr77;
		case 60: goto st99;
		case 62: goto tr78;
		case 63: goto tr76;
		case 95: goto tr76;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr72;
		} else if ( (*p) >= 9 )
			goto tr71;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr76;
		} else if ( (*p) >= 65 )
			goto tr76;
	} else
		goto tr76;
	goto st104;
tr76:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st106;
tr154:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st106;
st106:
	if ( ++p == pe )
		goto _out106;
case 106:
#line 3295 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr118;
		case 39: goto tr73;
		case 47: goto tr121;
		case 60: goto st99;
		case 61: goto tr122;
		case 62: goto tr123;
		case 63: goto st106;
		case 95: goto st106;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr119;
		} else if ( (*p) >= 9 )
			goto tr118;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st106;
		} else if ( (*p) >= 65 )
			goto st106;
	} else
		goto st106;
	goto st104;
tr352:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st107;
tr119:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st107;
st107:
	if ( ++p == pe )
		goto _out107;
case 107:
#line 3341 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr351;
		case 39: goto tr73;
		case 47: goto tr77;
		case 60: goto st99;
		case 61: goto st109;
		case 62: goto tr78;
		case 63: goto tr76;
		case 95: goto tr76;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr352;
		} else if ( (*p) >= 9 )
			goto tr351;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr76;
		} else if ( (*p) >= 65 )
			goto tr76;
	} else
		goto tr76;
	goto st104;
tr74:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st108;
tr77:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st108;
tr121:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st108;
tr151:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st108;
tr210:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st108;
tr211:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st108;
st108:
	if ( ++p == pe )
		goto _out108;
case 108:
#line 3440 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr71;
		case 39: goto tr73;
		case 47: goto tr74;
		case 60: goto st99;
		case 62: goto tr75;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr72;
	} else if ( (*p) >= 9 )
		goto tr71;
	goto st104;
tr122:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
	goto st109;
tr148:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st109;
st109:
	if ( ++p == pe )
		goto _out109;
case 109:
#line 3466 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr206;
		case 34: goto st112;
		case 39: goto tr209;
		case 47: goto tr210;
		case 60: goto st99;
		case 62: goto tr75;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr207;
	} else if ( (*p) >= 9 )
		goto tr206;
	goto tr146;
tr152:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st110;
tr206:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st110;
st110:
	if ( ++p == pe )
		goto _out110;
case 110:
#line 3498 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr152;
		case 34: goto st130;
		case 39: goto tr150;
		case 47: goto tr151;
		case 60: goto st99;
		case 62: goto tr29;
		case 63: goto tr154;
		case 95: goto tr154;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr153;
		} else if ( (*p) >= 9 )
			goto tr152;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr154;
		} else if ( (*p) >= 65 )
			goto tr154;
	} else
		goto tr154;
	goto tr146;
tr153:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st111;
tr207:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st111;
st111:
	if ( ++p == pe )
		goto _out111;
case 111:
#line 3541 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr206;
		case 34: goto st112;
		case 39: goto tr209;
		case 47: goto tr211;
		case 60: goto st99;
		case 62: goto tr78;
		case 63: goto tr154;
		case 95: goto tr154;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr207;
		} else if ( (*p) >= 9 )
			goto tr206;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr154;
		} else if ( (*p) >= 65 )
			goto tr154;
	} else
		goto tr154;
	goto tr146;
st112:
	if ( ++p == pe )
		goto _out112;
case 112:
	switch( (*p) ) {
		case 32: goto tr232;
		case 34: goto tr90;
		case 39: goto tr234;
		case 47: goto tr230;
		case 60: goto tr190;
		case 62: goto tr235;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr233;
	} else if ( (*p) >= 9 )
		goto tr232;
	goto tr181;
tr89:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st113;
tr233:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st113;
st113:
	if ( ++p == pe )
		goto _out113;
case 113:
#line 3605 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr88;
		case 34: goto tr90;
		case 39: goto tr91;
		case 47: goto tr95;
		case 60: goto st97;
		case 62: goto tr96;
		case 63: goto tr94;
		case 95: goto tr94;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr89;
		} else if ( (*p) >= 9 )
			goto tr88;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr94;
		} else if ( (*p) >= 65 )
			goto tr94;
	} else
		goto tr94;
	goto st95;
tr94:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st114;
tr189:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st114;
st114:
	if ( ++p == pe )
		goto _out114;
case 114:
#line 3667 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr130;
		case 34: goto tr90;
		case 39: goto tr91;
		case 47: goto tr133;
		case 60: goto st97;
		case 61: goto tr134;
		case 62: goto tr135;
		case 63: goto st114;
		case 95: goto st114;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr131;
		} else if ( (*p) >= 9 )
			goto tr130;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st114;
		} else if ( (*p) >= 65 )
			goto st114;
	} else
		goto st114;
	goto st95;
tr357:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st115;
tr107:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
	goto st115;
tr130:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st115;
st115:
	if ( ++p == pe )
		goto _out115;
case 115:
#line 3718 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st115;
		case 34: goto tr8;
		case 39: goto tr9;
		case 47: goto tr49;
		case 61: goto st118;
		case 62: goto tr50;
		case 63: goto tr48;
		case 95: goto tr48;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st115;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr48;
		} else if ( (*p) >= 65 )
			goto tr48;
	} else
		goto tr48;
	goto st97;
tr48:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st116;
tr193:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 94 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 79 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_akey = p; }
	goto st116;
st116:
	if ( ++p == pe )
		goto _out116;
case 116:
#line 3777 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr107;
		case 34: goto tr8;
		case 39: goto tr9;
		case 47: goto tr109;
		case 61: goto tr110;
		case 62: goto tr111;
		case 63: goto st116;
		case 95: goto st116;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr107;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st116;
		} else if ( (*p) >= 65 )
			goto st116;
	} else
		goto st116;
	goto st97;
tr49:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st117;
tr109:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st117;
tr194:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st117;
st117:
	if ( ++p == pe )
		goto _out117;
case 117:
#line 3826 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr8;
		case 39: goto tr9;
		case 62: goto tr46;
	}
	goto st97;
tr46:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 169 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 12;}
	goto st205;
tr50:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st205;
tr93:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st205;
tr96:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st205;
tr111:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st205;
tr135:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st205;
tr195:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st205;
tr235:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st205;
tr236:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 167 "ext/hpricot_scan/hpricot_scan.rl"
	{act = 10;}
	goto st205;
st205:
	if ( ++p == pe )
		goto _out205;
case 205:
#line 3958 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr8;
		case 39: goto tr9;
	}
	goto st97;
tr110:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
	goto st118;
st118:
	if ( ++p == pe )
		goto _out118;
case 118:
#line 3972 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr182;
		case 34: goto tr184;
		case 39: goto tr185;
		case 47: goto tr186;
		case 60: goto st97;
		case 62: goto tr50;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr183;
	} else if ( (*p) >= 9 )
		goto tr182;
	goto tr181;
tr182:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st119;
st119:
	if ( ++p == pe )
		goto _out119;
case 119:
#line 3995 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr187;
		case 34: goto tr184;
		case 39: goto tr185;
		case 47: goto tr186;
		case 60: goto st97;
		case 62: goto tr50;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr188;
	} else if ( (*p) >= 9 )
		goto tr187;
	goto tr181;
tr187:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st120;
tr226:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st120;
st120:
	if ( ++p == pe )
		goto _out120;
case 120:
#line 4027 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr187;
		case 34: goto tr184;
		case 39: goto tr185;
		case 47: goto tr186;
		case 60: goto st97;
		case 62: goto tr50;
		case 63: goto tr189;
		case 95: goto tr189;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr188;
		} else if ( (*p) >= 9 )
			goto tr187;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr189;
		} else if ( (*p) >= 65 )
			goto tr189;
	} else
		goto tr189;
	goto tr181;
tr188:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st121;
tr227:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st121;
st121:
	if ( ++p == pe )
		goto _out121;
case 121:
#line 4070 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr226;
		case 34: goto tr228;
		case 39: goto tr229;
		case 47: goto tr231;
		case 60: goto st97;
		case 62: goto tr96;
		case 63: goto tr189;
		case 95: goto tr189;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr227;
		} else if ( (*p) >= 9 )
			goto tr226;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr189;
		} else if ( (*p) >= 65 )
			goto tr189;
	} else
		goto tr189;
	goto tr181;
tr228:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st122;
st122:
	if ( ++p == pe )
		goto _out122;
case 122:
#line 4104 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr232;
		case 34: goto tr90;
		case 39: goto tr234;
		case 47: goto tr231;
		case 60: goto tr190;
		case 62: goto tr236;
		case 63: goto tr189;
		case 95: goto tr189;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr233;
		} else if ( (*p) >= 9 )
			goto tr232;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr189;
		} else if ( (*p) >= 65 )
			goto tr189;
	} else
		goto tr189;
	goto tr181;
tr92:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st123;
tr95:
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st123;
tr133:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st123;
tr186:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st123;
tr230:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
	goto st123;
tr231:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
#line 101 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    ATTR(akey, aval);
  }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st123;
st123:
	if ( ++p == pe )
		goto _out123;
case 123:
#line 4203 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr88;
		case 34: goto tr90;
		case 39: goto tr91;
		case 47: goto tr92;
		case 60: goto st97;
		case 62: goto tr93;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr89;
	} else if ( (*p) >= 9 )
		goto tr88;
	goto st95;
tr229:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st124;
st124:
	if ( ++p == pe )
		goto _out124;
case 124:
#line 4226 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr232;
		case 34: goto tr237;
		case 39: goto tr91;
		case 47: goto tr231;
		case 60: goto tr190;
		case 62: goto tr236;
		case 63: goto tr189;
		case 95: goto tr189;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr233;
		} else if ( (*p) >= 9 )
			goto tr232;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr189;
		} else if ( (*p) >= 65 )
			goto tr189;
	} else
		goto tr189;
	goto tr181;
tr184:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st125;
st125:
	if ( ++p == pe )
		goto _out125;
case 125:
#line 4260 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr192;
		case 34: goto tr8;
		case 39: goto tr191;
		case 47: goto tr194;
		case 62: goto tr195;
		case 63: goto tr193;
		case 95: goto tr193;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr192;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr193;
		} else if ( (*p) >= 65 )
			goto tr193;
	} else
		goto tr193;
	goto tr190;
tr185:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st126;
st126:
	if ( ++p == pe )
		goto _out126;
case 126:
#line 4290 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr192;
		case 34: goto tr199;
		case 39: goto tr9;
		case 47: goto tr194;
		case 62: goto tr195;
		case 63: goto tr193;
		case 95: goto tr193;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr192;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr193;
		} else if ( (*p) >= 65 )
			goto tr193;
	} else
		goto tr193;
	goto tr190;
tr134:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
	goto st127;
tr183:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st127;
st127:
	if ( ++p == pe )
		goto _out127;
case 127:
#line 4324 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr226;
		case 34: goto tr228;
		case 39: goto tr229;
		case 47: goto tr230;
		case 60: goto st97;
		case 62: goto tr93;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr227;
	} else if ( (*p) >= 9 )
		goto tr226;
	goto tr181;
tr358:
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st128;
tr131:
#line 87 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(akey, p); }
#line 83 "ext/hpricot_scan/hpricot_scan.rl"
	{ 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st128;
st128:
	if ( ++p == pe )
		goto _out128;
case 128:
#line 4359 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr357;
		case 34: goto tr90;
		case 39: goto tr91;
		case 47: goto tr95;
		case 60: goto st97;
		case 61: goto st127;
		case 62: goto tr96;
		case 63: goto tr94;
		case 95: goto tr94;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr358;
		} else if ( (*p) >= 9 )
			goto tr357;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr94;
		} else if ( (*p) >= 65 )
			goto tr94;
	} else
		goto tr94;
	goto st95;
tr209:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st129;
st129:
	if ( ++p == pe )
		goto _out129;
case 129:
#line 4394 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr212;
		case 39: goto tr73;
		case 47: goto tr211;
		case 60: goto tr155;
		case 62: goto tr215;
		case 63: goto tr154;
		case 95: goto tr154;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 13 )
				goto tr213;
		} else if ( (*p) >= 9 )
			goto tr212;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr154;
		} else if ( (*p) >= 65 )
			goto tr154;
	} else
		goto tr154;
	goto tr146;
st130:
	if ( ++p == pe )
		goto _out130;
case 130:
	switch( (*p) ) {
		case 34: goto tr8;
		case 39: goto tr191;
	}
	goto tr190;
tr150:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st131;
st131:
	if ( ++p == pe )
		goto _out131;
case 131:
#line 4436 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr156;
		case 39: goto tr3;
		case 47: goto tr158;
		case 62: goto tr159;
		case 63: goto tr157;
		case 95: goto tr157;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr156;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr157;
		} else if ( (*p) >= 65 )
			goto tr157;
	} else
		goto tr157;
	goto tr155;
tr147:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st132;
st132:
	if ( ++p == pe )
		goto _out132;
case 132:
#line 4465 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr152;
		case 34: goto st130;
		case 39: goto tr150;
		case 47: goto tr151;
		case 60: goto st99;
		case 62: goto tr29;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr153;
	} else if ( (*p) >= 9 )
		goto tr152;
	goto tr146;
tr170:
#line 82 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); }
	goto st133;
st133:
	if ( ++p == pe )
		goto _out133;
case 133:
#line 4488 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr177;
		case 34: goto tr3;
		case 47: goto tr179;
		case 62: goto tr180;
		case 63: goto tr178;
		case 95: goto tr178;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr177;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr178;
		} else if ( (*p) >= 65 )
			goto tr178;
	} else
		goto tr178;
	goto tr176;
st134:
	if ( ++p == pe )
		goto _out134;
case 134:
	switch( (*p) ) {
		case 34: goto tr199;
		case 39: goto tr9;
	}
	goto tr190;
st135:
	if ( ++p == pe )
		goto _out135;
case 135:
	switch( (*p) ) {
		case 32: goto tr212;
		case 39: goto tr73;
		case 47: goto tr210;
		case 60: goto tr155;
		case 62: goto tr214;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr213;
	} else if ( (*p) >= 9 )
		goto tr212;
	goto tr146;
st136:
	if ( ++p == pe )
		goto _out136;
case 136:
	if ( (*p) == 34 )
		goto tr3;
	goto tr176;
st137:
	if ( ++p == pe )
		goto _out137;
case 137:
	if ( (*p) == 39 )
		goto tr3;
	goto tr155;
tr137:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st138;
st138:
	if ( ++p == pe )
		goto _out138;
case 138:
#line 4557 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr143;
		case 34: goto st136;
		case 39: goto st137;
		case 47: goto tr141;
		case 60: goto tr62;
		case 62: goto tr142;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 13 )
			goto tr144;
	} else if ( (*p) >= 9 )
		goto tr143;
	goto tr136;
st139:
	if ( ++p == pe )
		goto _out139;
case 139:
	switch( (*p) ) {
		case 58: goto tr313;
		case 95: goto tr313;
		case 120: goto tr314;
	}
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr313;
	} else if ( (*p) >= 65 )
		goto tr313;
	goto tr270;
tr313:
#line 145 "ext/hpricot_scan/hpricot_scan.rl"
	{ TEXT_PASS(); }
	goto st140;
st140:
	if ( ++p == pe )
		goto _out140;
case 140:
#line 4595 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st206;
		case 63: goto st140;
		case 95: goto st140;
	}
	if ( (*p) < 48 ) {
		if ( (*p) > 13 ) {
			if ( 45 <= (*p) && (*p) <= 46 )
				goto st140;
		} else if ( (*p) >= 9 )
			goto st206;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st140;
		} else if ( (*p) >= 65 )
			goto st140;
	} else
		goto st140;
	goto tr270;
st206:
	if ( ++p == pe )
		goto _out206;
case 206:
	if ( (*p) == 32 )
		goto st206;
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st206;
	goto tr11;
tr314:
#line 145 "ext/hpricot_scan/hpricot_scan.rl"
	{ TEXT_PASS(); }
	goto st141;
st141:
	if ( ++p == pe )
		goto _out141;
case 141:
#line 4633 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st206;
		case 63: goto st140;
		case 95: goto st140;
		case 109: goto st142;
	}
	if ( (*p) < 48 ) {
		if ( (*p) > 13 ) {
			if ( 45 <= (*p) && (*p) <= 46 )
				goto st140;
		} else if ( (*p) >= 9 )
			goto st206;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st140;
		} else if ( (*p) >= 65 )
			goto st140;
	} else
		goto st140;
	goto tr270;
st142:
	if ( ++p == pe )
		goto _out142;
case 142:
	switch( (*p) ) {
		case 32: goto st206;
		case 63: goto st140;
		case 95: goto st140;
		case 108: goto st143;
	}
	if ( (*p) < 48 ) {
		if ( (*p) > 13 ) {
			if ( 45 <= (*p) && (*p) <= 46 )
				goto st140;
		} else if ( (*p) >= 9 )
			goto st206;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st140;
		} else if ( (*p) >= 65 )
			goto st140;
	} else
		goto st140;
	goto tr270;
st143:
	if ( ++p == pe )
		goto _out143;
case 143:
	switch( (*p) ) {
		case 32: goto tr13;
		case 63: goto st140;
		case 95: goto st140;
	}
	if ( (*p) < 48 ) {
		if ( (*p) > 13 ) {
			if ( 45 <= (*p) && (*p) <= 46 )
				goto st140;
		} else if ( (*p) >= 9 )
			goto tr13;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st140;
		} else if ( (*p) >= 65 )
			goto st140;
	} else
		goto st140;
	goto tr270;
tr13:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
	goto st207;
st207:
	if ( ++p == pe )
		goto _out207;
case 207:
#line 4712 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr13;
		case 118: goto st144;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto tr13;
	goto tr11;
st144:
	if ( ++p == pe )
		goto _out144;
case 144:
	if ( (*p) == 101 )
		goto st145;
	goto tr238;
st145:
	if ( ++p == pe )
		goto _out145;
case 145:
	if ( (*p) == 114 )
		goto st146;
	goto tr238;
st146:
	if ( ++p == pe )
		goto _out146;
case 146:
	if ( (*p) == 115 )
		goto st147;
	goto tr238;
st147:
	if ( ++p == pe )
		goto _out147;
case 147:
	if ( (*p) == 105 )
		goto st148;
	goto tr238;
st148:
	if ( ++p == pe )
		goto _out148;
case 148:
	if ( (*p) == 111 )
		goto st149;
	goto tr238;
st149:
	if ( ++p == pe )
		goto _out149;
case 149:
	if ( (*p) == 110 )
		goto st150;
	goto tr238;
st150:
	if ( ++p == pe )
		goto _out150;
case 150:
	switch( (*p) ) {
		case 32: goto st150;
		case 61: goto st151;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st150;
	goto tr238;
st151:
	if ( ++p == pe )
		goto _out151;
case 151:
	switch( (*p) ) {
		case 32: goto st151;
		case 34: goto st152;
		case 39: goto st194;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st151;
	goto tr238;
st152:
	if ( ++p == pe )
		goto _out152;
case 152:
	if ( (*p) == 95 )
		goto tr255;
	if ( (*p) < 48 ) {
		if ( 45 <= (*p) && (*p) <= 46 )
			goto tr255;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr255;
		} else if ( (*p) >= 65 )
			goto tr255;
	} else
		goto tr255;
	goto tr238;
tr255:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st153;
st153:
	if ( ++p == pe )
		goto _out153;
case 153:
#line 4811 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr248;
		case 95: goto st153;
	}
	if ( (*p) < 48 ) {
		if ( 45 <= (*p) && (*p) <= 46 )
			goto st153;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st153;
		} else if ( (*p) >= 65 )
			goto st153;
	} else
		goto st153;
	goto tr238;
tr248:
#line 88 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("version"), aval); }
	goto st154;
st154:
	if ( ++p == pe )
		goto _out154;
case 154:
#line 4836 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st155;
		case 63: goto st156;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st155;
	goto tr238;
st155:
	if ( ++p == pe )
		goto _out155;
case 155:
	switch( (*p) ) {
		case 32: goto st155;
		case 63: goto st156;
		case 101: goto st157;
		case 115: goto st170;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st155;
	goto tr238;
st156:
	if ( ++p == pe )
		goto _out156;
case 156:
	if ( (*p) == 62 )
		goto tr269;
	goto tr238;
st157:
	if ( ++p == pe )
		goto _out157;
case 157:
	if ( (*p) == 110 )
		goto st158;
	goto tr238;
st158:
	if ( ++p == pe )
		goto _out158;
case 158:
	if ( (*p) == 99 )
		goto st159;
	goto tr238;
st159:
	if ( ++p == pe )
		goto _out159;
case 159:
	if ( (*p) == 111 )
		goto st160;
	goto tr238;
st160:
	if ( ++p == pe )
		goto _out160;
case 160:
	if ( (*p) == 100 )
		goto st161;
	goto tr238;
st161:
	if ( ++p == pe )
		goto _out161;
case 161:
	if ( (*p) == 105 )
		goto st162;
	goto tr238;
st162:
	if ( ++p == pe )
		goto _out162;
case 162:
	if ( (*p) == 110 )
		goto st163;
	goto tr238;
st163:
	if ( ++p == pe )
		goto _out163;
case 163:
	if ( (*p) == 103 )
		goto st164;
	goto tr238;
st164:
	if ( ++p == pe )
		goto _out164;
case 164:
	switch( (*p) ) {
		case 32: goto st164;
		case 61: goto st165;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st164;
	goto tr238;
st165:
	if ( ++p == pe )
		goto _out165;
case 165:
	switch( (*p) ) {
		case 32: goto st165;
		case 34: goto st166;
		case 39: goto st192;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st165;
	goto tr238;
st166:
	if ( ++p == pe )
		goto _out166;
case 166:
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr256;
	} else if ( (*p) >= 65 )
		goto tr256;
	goto tr238;
tr256:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st167;
st167:
	if ( ++p == pe )
		goto _out167;
case 167:
#line 4954 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr250;
		case 95: goto st167;
	}
	if ( (*p) < 48 ) {
		if ( 45 <= (*p) && (*p) <= 46 )
			goto st167;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st167;
		} else if ( (*p) >= 65 )
			goto st167;
	} else
		goto st167;
	goto tr238;
tr250:
#line 89 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("encoding"), aval); }
	goto st168;
st168:
	if ( ++p == pe )
		goto _out168;
case 168:
#line 4979 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st169;
		case 63: goto st156;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st169;
	goto tr238;
st169:
	if ( ++p == pe )
		goto _out169;
case 169:
	switch( (*p) ) {
		case 32: goto st169;
		case 63: goto st156;
		case 115: goto st170;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st169;
	goto tr238;
st170:
	if ( ++p == pe )
		goto _out170;
case 170:
	if ( (*p) == 116 )
		goto st171;
	goto tr238;
st171:
	if ( ++p == pe )
		goto _out171;
case 171:
	if ( (*p) == 97 )
		goto st172;
	goto tr238;
st172:
	if ( ++p == pe )
		goto _out172;
case 172:
	if ( (*p) == 110 )
		goto st173;
	goto tr238;
st173:
	if ( ++p == pe )
		goto _out173;
case 173:
	if ( (*p) == 100 )
		goto st174;
	goto tr238;
st174:
	if ( ++p == pe )
		goto _out174;
case 174:
	if ( (*p) == 97 )
		goto st175;
	goto tr238;
st175:
	if ( ++p == pe )
		goto _out175;
case 175:
	if ( (*p) == 108 )
		goto st176;
	goto tr238;
st176:
	if ( ++p == pe )
		goto _out176;
case 176:
	if ( (*p) == 111 )
		goto st177;
	goto tr238;
st177:
	if ( ++p == pe )
		goto _out177;
case 177:
	if ( (*p) == 110 )
		goto st178;
	goto tr238;
st178:
	if ( ++p == pe )
		goto _out178;
case 178:
	if ( (*p) == 101 )
		goto st179;
	goto tr238;
st179:
	if ( ++p == pe )
		goto _out179;
case 179:
	switch( (*p) ) {
		case 32: goto st179;
		case 61: goto st180;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st179;
	goto tr238;
st180:
	if ( ++p == pe )
		goto _out180;
case 180:
	switch( (*p) ) {
		case 32: goto st180;
		case 34: goto st181;
		case 39: goto st187;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st180;
	goto tr238;
st181:
	if ( ++p == pe )
		goto _out181;
case 181:
	switch( (*p) ) {
		case 110: goto tr264;
		case 121: goto tr265;
	}
	goto tr238;
tr264:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st182;
st182:
	if ( ++p == pe )
		goto _out182;
case 182:
#line 5102 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 111 )
		goto st183;
	goto tr238;
st183:
	if ( ++p == pe )
		goto _out183;
case 183:
	if ( (*p) == 34 )
		goto tr252;
	goto tr238;
tr252:
#line 90 "ext/hpricot_scan/hpricot_scan.rl"
	{ SET(aval, p); ATTR(rb_str_new2("standalone"), aval); }
	goto st184;
st184:
	if ( ++p == pe )
		goto _out184;
case 184:
#line 5121 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st184;
		case 63: goto st156;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st184;
	goto tr238;
tr265:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st185;
st185:
	if ( ++p == pe )
		goto _out185;
case 185:
#line 5137 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 101 )
		goto st186;
	goto tr238;
st186:
	if ( ++p == pe )
		goto _out186;
case 186:
	if ( (*p) == 115 )
		goto st183;
	goto tr238;
st187:
	if ( ++p == pe )
		goto _out187;
case 187:
	switch( (*p) ) {
		case 110: goto tr391;
		case 121: goto tr392;
	}
	goto tr238;
tr391:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st188;
st188:
	if ( ++p == pe )
		goto _out188;
case 188:
#line 5165 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 111 )
		goto st189;
	goto tr238;
st189:
	if ( ++p == pe )
		goto _out189;
case 189:
	if ( (*p) == 39 )
		goto tr252;
	goto tr238;
tr392:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st190;
st190:
	if ( ++p == pe )
		goto _out190;
case 190:
#line 5184 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 101 )
		goto st191;
	goto tr238;
st191:
	if ( ++p == pe )
		goto _out191;
case 191:
	if ( (*p) == 115 )
		goto st189;
	goto tr238;
st192:
	if ( ++p == pe )
		goto _out192;
case 192:
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr369;
	} else if ( (*p) >= 65 )
		goto tr369;
	goto tr238;
tr369:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st193;
st193:
	if ( ++p == pe )
		goto _out193;
case 193:
#line 5213 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 39: goto tr250;
		case 95: goto st193;
	}
	if ( (*p) < 48 ) {
		if ( 45 <= (*p) && (*p) <= 46 )
			goto st193;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st193;
		} else if ( (*p) >= 65 )
			goto st193;
	} else
		goto st193;
	goto tr238;
st194:
	if ( ++p == pe )
		goto _out194;
case 194:
	if ( (*p) == 95 )
		goto tr368;
	if ( (*p) < 48 ) {
		if ( 45 <= (*p) && (*p) <= 46 )
			goto tr368;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr368;
		} else if ( (*p) >= 65 )
			goto tr368;
	} else
		goto tr368;
	goto tr238;
tr368:
#line 78 "ext/hpricot_scan/hpricot_scan.rl"
	{ mark_aval = p; }
	goto st195;
st195:
	if ( ++p == pe )
		goto _out195;
case 195:
#line 5256 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 39: goto tr248;
		case 95: goto st195;
	}
	if ( (*p) < 48 ) {
		if ( 45 <= (*p) && (*p) <= 46 )
			goto st195;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st195;
		} else if ( (*p) >= 65 )
			goto st195;
	} else
		goto st195;
	goto tr238;
tr395:
#line 150 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st208;
tr397:
#line 150 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st208;
tr398:
#line 109 "ext/hpricot_scan/hpricot_scan.rl"
	{curline += 1;}
#line 150 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st208;
tr400:
#line 150 "ext/hpricot_scan/hpricot_scan.rl"
	{{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st208;
tr401:
#line 149 "ext/hpricot_scan/hpricot_scan.rl"
	{ EBLK(comment, 3); {goto st198;} }
#line 149 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{p = ((tokend))-1;}}
	goto st208;
st208:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokstart = 0;}
	if ( ++p == pe )
		goto _out208;
case 208:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokstart = p;}
#line 5305 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 10: goto tr398;
		case 45: goto tr399;
	}
	goto tr397;
tr399:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
	goto st209;
st209:
	if ( ++p == pe )
		goto _out209;
case 209:
#line 5319 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 45 )
		goto st196;
	goto tr395;
st196:
	if ( ++p == pe )
		goto _out196;
case 196:
	if ( (*p) == 62 )
		goto tr401;
	goto tr400;
tr402:
#line 155 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st210;
tr404:
#line 155 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st210;
tr405:
#line 109 "ext/hpricot_scan/hpricot_scan.rl"
	{curline += 1;}
#line 155 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st210;
tr407:
#line 155 "ext/hpricot_scan/hpricot_scan.rl"
	{{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st210;
tr408:
#line 154 "ext/hpricot_scan/hpricot_scan.rl"
	{ EBLK(cdata, 3); {goto st198;} }
#line 154 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{p = ((tokend))-1;}}
	goto st210;
st210:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokstart = 0;}
	if ( ++p == pe )
		goto _out210;
case 210:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokstart = p;}
#line 5362 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 10: goto tr405;
		case 93: goto tr406;
	}
	goto tr404;
tr406:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;}
	goto st211;
st211:
	if ( ++p == pe )
		goto _out211;
case 211:
#line 5376 "ext/hpricot_scan/hpricot_scan.c"
	if ( (*p) == 93 )
		goto st197;
	goto tr402;
st197:
	if ( ++p == pe )
		goto _out197;
case 197:
	if ( (*p) == 62 )
		goto tr408;
	goto tr407;
tr409:
#line 160 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st212;
tr410:
#line 159 "ext/hpricot_scan/hpricot_scan.rl"
	{ EBLK(procins, 2); {goto st198;} }
#line 159 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{p = ((tokend))-1;}}
	goto st212;
tr411:
#line 160 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st212;
tr412:
#line 109 "ext/hpricot_scan/hpricot_scan.rl"
	{curline += 1;}
#line 160 "ext/hpricot_scan/hpricot_scan.rl"
	{tokend = p+1;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	goto st212;
st212:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokstart = 0;}
	if ( ++p == pe )
		goto _out212;
case 212:
#line 1 "ext/hpricot_scan/hpricot_scan.rl"
	{tokstart = p;}
#line 5415 "ext/hpricot_scan/hpricot_scan.c"
	switch( (*p) ) {
		case 10: goto tr412;
		case 63: goto st213;
	}
	goto tr411;
st213:
	if ( ++p == pe )
		goto _out213;
case 213:
	if ( (*p) == 62 )
		goto tr410;
	goto tr409;
	}
	_out198: cs = 198; goto _out; 
	_out199: cs = 199; goto _out; 
	_out0: cs = 0; goto _out; 
	_out1: cs = 1; goto _out; 
	_out2: cs = 2; goto _out; 
	_out3: cs = 3; goto _out; 
	_out4: cs = 4; goto _out; 
	_out5: cs = 5; goto _out; 
	_out6: cs = 6; goto _out; 
	_out7: cs = 7; goto _out; 
	_out8: cs = 8; goto _out; 
	_out9: cs = 9; goto _out; 
	_out10: cs = 10; goto _out; 
	_out11: cs = 11; goto _out; 
	_out12: cs = 12; goto _out; 
	_out13: cs = 13; goto _out; 
	_out14: cs = 14; goto _out; 
	_out15: cs = 15; goto _out; 
	_out16: cs = 16; goto _out; 
	_out17: cs = 17; goto _out; 
	_out18: cs = 18; goto _out; 
	_out19: cs = 19; goto _out; 
	_out20: cs = 20; goto _out; 
	_out21: cs = 21; goto _out; 
	_out22: cs = 22; goto _out; 
	_out23: cs = 23; goto _out; 
	_out24: cs = 24; goto _out; 
	_out25: cs = 25; goto _out; 
	_out26: cs = 26; goto _out; 
	_out27: cs = 27; goto _out; 
	_out28: cs = 28; goto _out; 
	_out29: cs = 29; goto _out; 
	_out30: cs = 30; goto _out; 
	_out31: cs = 31; goto _out; 
	_out32: cs = 32; goto _out; 
	_out33: cs = 33; goto _out; 
	_out34: cs = 34; goto _out; 
	_out35: cs = 35; goto _out; 
	_out36: cs = 36; goto _out; 
	_out37: cs = 37; goto _out; 
	_out38: cs = 38; goto _out; 
	_out39: cs = 39; goto _out; 
	_out200: cs = 200; goto _out; 
	_out40: cs = 40; goto _out; 
	_out41: cs = 41; goto _out; 
	_out201: cs = 201; goto _out; 
	_out42: cs = 42; goto _out; 
	_out43: cs = 43; goto _out; 
	_out202: cs = 202; goto _out; 
	_out44: cs = 44; goto _out; 
	_out45: cs = 45; goto _out; 
	_out46: cs = 46; goto _out; 
	_out47: cs = 47; goto _out; 
	_out48: cs = 48; goto _out; 
	_out49: cs = 49; goto _out; 
	_out50: cs = 50; goto _out; 
	_out51: cs = 51; goto _out; 
	_out52: cs = 52; goto _out; 
	_out53: cs = 53; goto _out; 
	_out54: cs = 54; goto _out; 
	_out55: cs = 55; goto _out; 
	_out56: cs = 56; goto _out; 
	_out57: cs = 57; goto _out; 
	_out58: cs = 58; goto _out; 
	_out59: cs = 59; goto _out; 
	_out60: cs = 60; goto _out; 
	_out61: cs = 61; goto _out; 
	_out62: cs = 62; goto _out; 
	_out63: cs = 63; goto _out; 
	_out64: cs = 64; goto _out; 
	_out65: cs = 65; goto _out; 
	_out66: cs = 66; goto _out; 
	_out67: cs = 67; goto _out; 
	_out68: cs = 68; goto _out; 
	_out69: cs = 69; goto _out; 
	_out70: cs = 70; goto _out; 
	_out71: cs = 71; goto _out; 
	_out72: cs = 72; goto _out; 
	_out73: cs = 73; goto _out; 
	_out74: cs = 74; goto _out; 
	_out75: cs = 75; goto _out; 
	_out76: cs = 76; goto _out; 
	_out77: cs = 77; goto _out; 
	_out78: cs = 78; goto _out; 
	_out79: cs = 79; goto _out; 
	_out80: cs = 80; goto _out; 
	_out81: cs = 81; goto _out; 
	_out82: cs = 82; goto _out; 
	_out83: cs = 83; goto _out; 
	_out203: cs = 203; goto _out; 
	_out84: cs = 84; goto _out; 
	_out85: cs = 85; goto _out; 
	_out86: cs = 86; goto _out; 
	_out87: cs = 87; goto _out; 
	_out88: cs = 88; goto _out; 
	_out89: cs = 89; goto _out; 
	_out90: cs = 90; goto _out; 
	_out91: cs = 91; goto _out; 
	_out92: cs = 92; goto _out; 
	_out93: cs = 93; goto _out; 
	_out94: cs = 94; goto _out; 
	_out95: cs = 95; goto _out; 
	_out96: cs = 96; goto _out; 
	_out97: cs = 97; goto _out; 
	_out98: cs = 98; goto _out; 
	_out99: cs = 99; goto _out; 
	_out100: cs = 100; goto _out; 
	_out101: cs = 101; goto _out; 
	_out102: cs = 102; goto _out; 
	_out204: cs = 204; goto _out; 
	_out103: cs = 103; goto _out; 
	_out104: cs = 104; goto _out; 
	_out105: cs = 105; goto _out; 
	_out106: cs = 106; goto _out; 
	_out107: cs = 107; goto _out; 
	_out108: cs = 108; goto _out; 
	_out109: cs = 109; goto _out; 
	_out110: cs = 110; goto _out; 
	_out111: cs = 111; goto _out; 
	_out112: cs = 112; goto _out; 
	_out113: cs = 113; goto _out; 
	_out114: cs = 114; goto _out; 
	_out115: cs = 115; goto _out; 
	_out116: cs = 116; goto _out; 
	_out117: cs = 117; goto _out; 
	_out205: cs = 205; goto _out; 
	_out118: cs = 118; goto _out; 
	_out119: cs = 119; goto _out; 
	_out120: cs = 120; goto _out; 
	_out121: cs = 121; goto _out; 
	_out122: cs = 122; goto _out; 
	_out123: cs = 123; goto _out; 
	_out124: cs = 124; goto _out; 
	_out125: cs = 125; goto _out; 
	_out126: cs = 126; goto _out; 
	_out127: cs = 127; goto _out; 
	_out128: cs = 128; goto _out; 
	_out129: cs = 129; goto _out; 
	_out130: cs = 130; goto _out; 
	_out131: cs = 131; goto _out; 
	_out132: cs = 132; goto _out; 
	_out133: cs = 133; goto _out; 
	_out134: cs = 134; goto _out; 
	_out135: cs = 135; goto _out; 
	_out136: cs = 136; goto _out; 
	_out137: cs = 137; goto _out; 
	_out138: cs = 138; goto _out; 
	_out139: cs = 139; goto _out; 
	_out140: cs = 140; goto _out; 
	_out206: cs = 206; goto _out; 
	_out141: cs = 141; goto _out; 
	_out142: cs = 142; goto _out; 
	_out143: cs = 143; goto _out; 
	_out207: cs = 207; goto _out; 
	_out144: cs = 144; goto _out; 
	_out145: cs = 145; goto _out; 
	_out146: cs = 146; goto _out; 
	_out147: cs = 147; goto _out; 
	_out148: cs = 148; goto _out; 
	_out149: cs = 149; goto _out; 
	_out150: cs = 150; goto _out; 
	_out151: cs = 151; goto _out; 
	_out152: cs = 152; goto _out; 
	_out153: cs = 153; goto _out; 
	_out154: cs = 154; goto _out; 
	_out155: cs = 155; goto _out; 
	_out156: cs = 156; goto _out; 
	_out157: cs = 157; goto _out; 
	_out158: cs = 158; goto _out; 
	_out159: cs = 159; goto _out; 
	_out160: cs = 160; goto _out; 
	_out161: cs = 161; goto _out; 
	_out162: cs = 162; goto _out; 
	_out163: cs = 163; goto _out; 
	_out164: cs = 164; goto _out; 
	_out165: cs = 165; goto _out; 
	_out166: cs = 166; goto _out; 
	_out167: cs = 167; goto _out; 
	_out168: cs = 168; goto _out; 
	_out169: cs = 169; goto _out; 
	_out170: cs = 170; goto _out; 
	_out171: cs = 171; goto _out; 
	_out172: cs = 172; goto _out; 
	_out173: cs = 173; goto _out; 
	_out174: cs = 174; goto _out; 
	_out175: cs = 175; goto _out; 
	_out176: cs = 176; goto _out; 
	_out177: cs = 177; goto _out; 
	_out178: cs = 178; goto _out; 
	_out179: cs = 179; goto _out; 
	_out180: cs = 180; goto _out; 
	_out181: cs = 181; goto _out; 
	_out182: cs = 182; goto _out; 
	_out183: cs = 183; goto _out; 
	_out184: cs = 184; goto _out; 
	_out185: cs = 185; goto _out; 
	_out186: cs = 186; goto _out; 
	_out187: cs = 187; goto _out; 
	_out188: cs = 188; goto _out; 
	_out189: cs = 189; goto _out; 
	_out190: cs = 190; goto _out; 
	_out191: cs = 191; goto _out; 
	_out192: cs = 192; goto _out; 
	_out193: cs = 193; goto _out; 
	_out194: cs = 194; goto _out; 
	_out195: cs = 195; goto _out; 
	_out208: cs = 208; goto _out; 
	_out209: cs = 209; goto _out; 
	_out196: cs = 196; goto _out; 
	_out210: cs = 210; goto _out; 
	_out211: cs = 211; goto _out; 
	_out197: cs = 197; goto _out; 
	_out212: cs = 212; goto _out; 
	_out213: cs = 213; goto _out; 

	_out: {}
	}
#line 264 "ext/hpricot_scan/hpricot_scan.rl"
    
    if ( cs == hpricot_scan_error ) {
      free(buf);
      if ( !NIL_P(tag) )
      {
        rb_raise(rb_eHpricotParseError, "parse error on element <%s>, starting on line %d.\n" NO_WAY_SERIOUSLY, RSTRING(tag)->ptr, curline);
      }
      else
      {
        rb_raise(rb_eHpricotParseError, "parse error on line %d.\n" NO_WAY_SERIOUSLY, curline);
      }
    }
    
    if ( done && ele_open )
    {
      ele_open = 0;
      if (tokstart > 0) {
        mark_tag = tokstart;
        tokstart = 0;
        text = 1;
      }
    }

    if ( tokstart == 0 )
    {
      have = 0;
      /* text nodes have no tokstart because each byte is parsed alone */
      if ( mark_tag != NULL && text == 1 )
      {
        if (done)
        {
          if (mark_tag < p-1)
          {
            CAT(tag, p-1);
            ELE(text);
          }
        }
        else
        {
          CAT(tag, p);
        }
      }
      mark_tag = buf;
    }
    else
    {
      have = pe - tokstart;
      memmove( buf, tokstart, have );
      SLIDE(tag);
      SLIDE(akey);
      SLIDE(aval);
      tokend = buf + (tokend - tokstart);
      tokstart = buf;
    }
  }
  free(buf);
}

void Init_hpricot_scan()
{
  VALUE mHpricot = rb_define_module("Hpricot");
  rb_define_attr(rb_singleton_class(mHpricot), "buffer_size", 1, 1);
  rb_define_singleton_method(mHpricot, "scan", hpricot_scan, 1);
  rb_eHpricotParseError = rb_define_class_under(mHpricot, "ParseError", rb_eException);

  s_read = rb_intern("read");
  s_to_str = rb_intern("to_str");
  sym_xmldecl = ID2SYM(rb_intern("xmldecl"));
  sym_doctype = ID2SYM(rb_intern("doctype"));
  sym_procins = ID2SYM(rb_intern("procins"));
  sym_stag = ID2SYM(rb_intern("stag"));
  sym_etag = ID2SYM(rb_intern("etag"));
  sym_emptytag = ID2SYM(rb_intern("emptytag"));
  sym_comment = ID2SYM(rb_intern("comment"));
  sym_cdata = ID2SYM(rb_intern("cdata"));
  sym_text = ID2SYM(rb_intern("text"));
}
