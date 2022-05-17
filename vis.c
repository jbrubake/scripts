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
 * abstract: show non-printing characters as hexadecimal escapes/
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

/*
 * Read from fp and convert (or discard if strip == 1)
 * non-printable characters
 */
void
vis (FILE *fp, int strip)
{
    int c;

    while ((c = getc (fp)) != EOF)
        if (isascii (c) &&
                (isprint (c) || c == '\n' || c == '\t' || c == ' '))
            putchar (c);
        else if (!strip)
            printf ("\\0x%02x", c);
        else /* strip == 1 */
            ; /* discard */
}

int
main (int argc, char **argv)
{
    int strip = 0; /* Convert non-printable chars by default */

    /*
     * Simple option processing
     */
    while (argc > 1 && argv[1][0] == '-')
    {
        switch (argv[1][1])
        {
            case 's': /* -s: strip funny chars */
                strip = 1;
                break;
            default:
                fprintf (stderr, "%s: unkown arg %s\n",
                        argv[0], argv[1]);
                exit (1);
                break;
        }
        argc--;
        argv++;
    }

    /*
     * If there are no args, process stdin,
     * otherwise process args as filenames
     */
    if (argc == 1)
        vis (stdin, strip);
    else
    {
        int i;
        FILE *fp;

        for (i = 1; i < argc; i++)
            if ((fp = fopen (argv[i], "r")) == NULL)
            {
                fprintf (stderr, "%s: can't open %s\n",
                        argv[0], argv[i]);
                exit (1);
            }
            else
            {
                vis (fp, strip);
                fclose (fp);
            }
    }

    exit (0);
}

