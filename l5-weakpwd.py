#!/usr/bin/python

#####################
#author: binhoul
#
#####################

inlists = [
     [str(x) for x in range(10)] ,
     [chr(c) for c in range(ord('a'), ord('z') + 1)]

]

#length of password ,from 1 to 8 , except empty password
pwdlength_min = 1
pwdlength_max = 8

def weakpass(inarray, pwdlength_max):
    """
    generate the weakpassword for two type,
    12345...
    or
    aaaaa...
    length between 1 and 8
    """
    filehandle = open("./password.list",'a')
    atomlist = inarray
    increase_distance = [0,1]
    for distance in increase_distance:
        for baseword in atomlist:
            weakpass = baseword
            currword = baseword
            tmplength = 1
            filehandle.write(weakpass + '\n')
            while tmplength < pwdlength_max and atomlist.index(baseword) + tmplength * distance < len(atomlist):
                nextword = atomlist[atomlist.index(currword) + distance ]
                weakpass += nextword
                filehandle.write(weakpass + '\n')
                tmplength += 1
                currword = nextword
            else:
                continue
    filehandle.close()


if "__main__" == __name__:
    for inlist in inlists:
        weakpass(inlist, pwdlength_max)
