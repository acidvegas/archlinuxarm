static const char font[]       = "Misc Ohsnap.Icons:style=Regular:size=11";
static const char* normbgcolor = "#222222";
static const char* normfgcolor = "#cccccc";
static const char* selbgcolor  = "#555555";
static const char* selfgcolor  = "#ffffff";
static const char* urgbgcolor  = "#111111";
static const char* urgfgcolor  = "#cc0000";
static const char before[]     = "<";
static const char after[]      = ">";
static const char titletrim[]  = "...";
static const int  tabwidth     = 50;
static const Bool foreground   = True;
static       Bool urgentswitch = False;
static int        newposition  = 0;
static       Bool npisrelative = False;

#define SETPROP(p) { \
        .v = (char *[]){ "/bin/sh", "-c", \
                "prop=\"`xwininfo -children -id $1 | grep '^     0x' |" \
                "sed -e's@^ *\\(0x[0-9a-f]*\\) \"\\([^\"]*\\)\".*@\\1 \\2@' |" \
                "xargs -0 printf %b | dmenu -l 10 -w $1`\" &&" \
                "xprop -id $1 -f $0 8s -set $0 \"$prop\"", \
                p, winid, NULL \
        } \
}

#define MODKEY ControlMask
static Key keys[] = {
	{ MODKEY|ShiftMask, XK_Return, focusonce,  { 0 } },
	{ MODKEY|ShiftMask, XK_Return, spawn,      { 0 } },
	{ MODKEY,           XK_Left,   rotate,     { .i = -1 } },
	{ MODKEY,           XK_Right,  rotate,     { .i = +1 } },
	{ MODKEY|ShiftMask, XK_Left,   movetab,    { .i = -1 } },
	{ MODKEY|ShiftMask, XK_Right,  movetab,    { .i = +1 } },
	{ MODKEY|ShiftMask, XK_k,      killclient, { 0 } },
	{ MODKEY,           XK_1,      move,       { .i = 0 } },
	{ MODKEY,           XK_2,      move,       { .i = 1 } },
	{ MODKEY,           XK_3,      move,       { .i = 2 } },
	{ MODKEY,           XK_4,      move,       { .i = 3 } },
	{ MODKEY,           XK_5,      move,       { .i = 4 } },
	{ MODKEY,           XK_6,      move,       { .i = 5 } },
	{ MODKEY,           XK_7,      move,       { .i = 6 } },
	{ MODKEY,           XK_8,      move,       { .i = 7 } },
	{ MODKEY,           XK_9,      move,       { .i = 8 } },
	{ MODKEY,           XK_0,      move,       { .i = 9 } },
};

