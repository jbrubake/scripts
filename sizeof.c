/*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Copyright 2014 Jeremy Brubaker <jbru362@gmail.com>
 *
 * abstract: print sizes of C data types
 *
 */
#include <limits.h>
#include <stddef.h>
#include <stdio.h>

int
main ()
{
    puts ("sizeof basic types");
    printf ("char          %lu\n", sizeof (char));
    printf ("short         %lu\n", sizeof (short));
    printf ("int           %lu\n", sizeof (int));
    printf ("long          %lu\n", sizeof (long));
    printf ("long long     %lu\n", sizeof (long long));
    printf ("float         %lu\n", sizeof (float));
    printf ("double        %lu\n", sizeof (double));
    printf ("long double   %lu\n", sizeof (long double));
    printf ("size_t        %lu\n", sizeof (size_t));
    printf ("ptrdiff_t     %lu\n", sizeof (ptrdiff_t));
    printf ("wchar_t       %lu\n", sizeof (wchar_t));
    puts ("");
    puts ("integer limits");
    printf ("CHAR_BIT = %i\n", CHAR_BIT);
    printf ("UCHAR_MAX = %u\n", UCHAR_MAX);
    printf ("CHAR_MIN = %i\n", CHAR_MIN);
    printf ("CHAR_MAX = %i\n", CHAR_MAX);
    printf ("SCHAR_MIN = %i\n", SCHAR_MIN);
    printf ("SCHAR_MAX = %i\n", SCHAR_MAX);
    printf ("MB_LEN_MAX = %i\n", MB_LEN_MAX);
    puts ("");
    printf ("USHRT_MAX = %u\n", USHRT_MAX);
    printf ("SHRT_MIN = %i\n", SHRT_MIN);
    printf ("SHRT_MAX = %i\n", SHRT_MAX);
    puts ("");
    printf ("UINT_MAX = %u\n", UINT_MAX);
    printf ("INT_MIN = %i\n", INT_MIN);
    printf ("INT_MAX = %i\n", INT_MAX);
    puts ("");
    printf ("ULONG_MAX = %lu\n", ULONG_MAX);
    printf ("LONG_MIN = %li\n", LONG_MIN);
    printf ("LONG_MAX = %li\n", LONG_MAX);
    puts ("");
    printf ("ULLONG_MAX = %llu\n", ULLONG_MAX);
    printf ("LLONG_MIN = %lli\n", LLONG_MIN);
    printf ("LLONG_MAX = %lli\n", LLONG_MAX);
    return 0;
}

