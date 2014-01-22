//
//  CnCalendar.m
//  Picker
//
//  Created by Lost on 12-5-21.
//  Copyright 2012 Lost. All rights reserved.
//

#import "CnCalendar.h"

const  int START_YEAR =1901;      
const  int END_YEAR   =2050;  

static int32_t gLunarHolDay[]=      
{      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1901      
    0X96, 0XA4, 0X96, 0X96, 0X97, 0X87, 0X79, 0X79, 0X79, 0X69, 0X78, 0X78,   //1902      
    0X96, 0XA5, 0X87, 0X96, 0X87, 0X87, 0X79, 0X69, 0X69, 0X69, 0X78, 0X78,   //1903      
    0X86, 0XA5, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X78, 0X87,   //1904      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1905      
    0X96, 0XA4, 0X96, 0X96, 0X97, 0X97, 0X79, 0X79, 0X79, 0X69, 0X78, 0X78,   //1906      
    0X96, 0XA5, 0X87, 0X96, 0X87, 0X87, 0X79, 0X69, 0X69, 0X69, 0X78, 0X78,   //1907      
    0X86, 0XA5, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //1908      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1909      
    0X96, 0XA4, 0X96, 0X96, 0X97, 0X97, 0X79, 0X79, 0X79, 0X69, 0X78, 0X78,   //1910      
    0X96, 0XA5, 0X87, 0X96, 0X87, 0X87, 0X79, 0X69, 0X69, 0X69, 0X78, 0X78,   //1911      
    0X86, 0XA5, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //1912      
    0X95, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1913      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X79, 0X79, 0X79, 0X69, 0X78, 0X78,   //1914      
    0X96, 0XA5, 0X97, 0X96, 0X97, 0X87, 0X79, 0X79, 0X69, 0X69, 0X78, 0X78,   //1915      
    0X96, 0XA5, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //1916      
    0X95, 0XB4, 0X96, 0XA6, 0X96, 0X97, 0X78, 0X79, 0X78, 0X69, 0X78, 0X87,   //1917      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X79, 0X79, 0X79, 0X69, 0X78, 0X77,   //1918      
    0X96, 0XA5, 0X97, 0X96, 0X97, 0X87, 0X79, 0X79, 0X69, 0X69, 0X78, 0X78,   //1919      
    0X96, 0XA5, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //1920      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X78, 0X79, 0X78, 0X69, 0X78, 0X87,   //1921      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X79, 0X79, 0X79, 0X69, 0X78, 0X77,   //1922      
    0X96, 0XA4, 0X96, 0X96, 0X97, 0X87, 0X79, 0X79, 0X69, 0X69, 0X78, 0X78,   //1923      
    0X96, 0XA5, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //1924      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X78, 0X79, 0X78, 0X69, 0X78, 0X87,   //1925      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1926      
    0X96, 0XA4, 0X96, 0X96, 0X97, 0X87, 0X79, 0X79, 0X79, 0X69, 0X78, 0X78,   //1927      
    0X96, 0XA5, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //1928      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //1929      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1930      
    0X96, 0XA4, 0X96, 0X96, 0X97, 0X87, 0X79, 0X79, 0X79, 0X69, 0X78, 0X78,   //1931      
    0X96, 0XA5, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //1932      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //1933      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1934      
    0X96, 0XA4, 0X96, 0X96, 0X97, 0X97, 0X79, 0X79, 0X79, 0X69, 0X78, 0X78,   //1935      
    0X96, 0XA5, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //1936      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //1937      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1938      
    0X96, 0XA4, 0X96, 0X96, 0X97, 0X97, 0X79, 0X79, 0X79, 0X69, 0X78, 0X78,   //1939      
    0X96, 0XA5, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //1940      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //1941      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1942      
    0X96, 0XA4, 0X96, 0X96, 0X97, 0X97, 0X79, 0X79, 0X79, 0X69, 0X78, 0X78,   //1943      
    0X96, 0XA5, 0X96, 0XA5, 0XA6, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //1944      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //1945      
    0X95, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X78, 0X69, 0X78, 0X77,   //1946      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X79, 0X79, 0X79, 0X69, 0X78, 0X78,   //1947      
    0X96, 0XA5, 0XA6, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //1948      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X79, 0X78, 0X79, 0X77, 0X87,   //1949      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X78, 0X79, 0X78, 0X69, 0X78, 0X77,   //1950      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X79, 0X79, 0X79, 0X69, 0X78, 0X78,   //1951      
    0X96, 0XA5, 0XA6, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //1952      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //1953      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X78, 0X79, 0X78, 0X68, 0X78, 0X87,   //1954      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1955      
    0X96, 0XA5, 0XA5, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //1956      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //1957      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //1958      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1959      
    0X96, 0XA4, 0XA5, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //1960      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //1961      
    0X96, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //1962      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1963      
    0X96, 0XA4, 0XA5, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //1964      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //1965      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //1966      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1967      
    0X96, 0XA4, 0XA5, 0XA5, 0XA6, 0XA6, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //1968      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //1969      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //1970      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X79, 0X69, 0X78, 0X77,   //1971      
    0X96, 0XA4, 0XA5, 0XA5, 0XA6, 0XA6, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //1972      
    0XA5, 0XB5, 0X96, 0XA5, 0XA6, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //1973      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //1974      
    0X96, 0XB4, 0X96, 0XA6, 0X97, 0X97, 0X78, 0X79, 0X78, 0X69, 0X78, 0X77,   //1975      
    0X96, 0XA4, 0XA5, 0XB5, 0XA6, 0XA6, 0X88, 0X89, 0X88, 0X78, 0X87, 0X87,   //1976      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //1977      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X78, 0X87,   //1978      
    0X96, 0XB4, 0X96, 0XA6, 0X96, 0X97, 0X78, 0X79, 0X78, 0X69, 0X78, 0X77,   //1979      
    0X96, 0XA4, 0XA5, 0XB5, 0XA6, 0XA6, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //1980      
    0XA5, 0XB4, 0X96, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X77, 0X87,   //1981      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //1982      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X78, 0X79, 0X78, 0X69, 0X78, 0X77,   //1983      
    0X96, 0XB4, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X87,   //1984      
    0XA5, 0XB4, 0XA6, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //1985      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //1986      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X79, 0X78, 0X69, 0X78, 0X87,   //1987      
    0X96, 0XB4, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X86,   //1988      
    0XA5, 0XB4, 0XA5, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //1989      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //1990      
    0X95, 0XB4, 0X96, 0XA5, 0X86, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //1991      
    0X96, 0XB4, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X86,   //1992      
    0XA5, 0XB3, 0XA5, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //1993      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //1994      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X76, 0X78, 0X69, 0X78, 0X87,   //1995      
    0X96, 0XB4, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X86,   //1996      
    0XA5, 0XB3, 0XA5, 0XA5, 0XA6, 0XA6, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //1997      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //1998      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //1999      
    0X96, 0XB4, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X86,   //2000      
    0XA5, 0XB3, 0XA5, 0XA5, 0XA6, 0XA6, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //2001      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //2002      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //2003      
    0X96, 0XB4, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X86,   //2004      
    0XA5, 0XB3, 0XA5, 0XA5, 0XA6, 0XA6, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //2005      
    0XA5, 0XB4, 0X96, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //2006      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X69, 0X78, 0X87,   //2007      
    0X96, 0XB4, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X87, 0X78, 0X87, 0X86,   //2008      
    0XA5, 0XB3, 0XA5, 0XB5, 0XA6, 0XA6, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //2009      
    0XA5, 0XB4, 0X96, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //2010      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X78, 0X87,   //2011      
    0X96, 0XB4, 0XA5, 0XB5, 0XA5, 0XA6, 0X87, 0X88, 0X87, 0X78, 0X87, 0X86,   //2012      
    0XA5, 0XB3, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X87,   //2013      
    0XA5, 0XB4, 0X96, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //2014      
    0X95, 0XB4, 0X96, 0XA5, 0X96, 0X97, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //2015      
    0X95, 0XB4, 0XA5, 0XB4, 0XA5, 0XA6, 0X87, 0X88, 0X87, 0X78, 0X87, 0X86,   //2016      
    0XA5, 0XC3, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X87,   //2017      
    0XA5, 0XB4, 0XA6, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //2018      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //2019      
    0X95, 0XB4, 0XA5, 0XB4, 0XA5, 0XA6, 0X97, 0X87, 0X87, 0X78, 0X87, 0X86,   //2020      
    0XA5, 0XC3, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X86,   //2021      
    0XA5, 0XB4, 0XA5, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //2022      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X79, 0X77, 0X87,   //2023      
    0X95, 0XB4, 0XA5, 0XB4, 0XA5, 0XA6, 0X97, 0X87, 0X87, 0X78, 0X87, 0X96,   //2024      
    0XA5, 0XC3, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X86,   //2025      
    0XA5, 0XB3, 0XA5, 0XA5, 0XA6, 0XA6, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //2026      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //2027      
    0X95, 0XB4, 0XA5, 0XB4, 0XA5, 0XA6, 0X97, 0X87, 0X87, 0X78, 0X87, 0X96,   //2028      
    0XA5, 0XC3, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X86,   //2029      
    0XA5, 0XB3, 0XA5, 0XA5, 0XA6, 0XA6, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //2030      
    0XA5, 0XB4, 0X96, 0XA5, 0X96, 0X96, 0X88, 0X78, 0X78, 0X78, 0X87, 0X87,   //2031      
    0X95, 0XB4, 0XA5, 0XB4, 0XA5, 0XA6, 0X97, 0X87, 0X87, 0X78, 0X87, 0X96,   //2032      
    0XA5, 0XC3, 0XA5, 0XB5, 0XA6, 0XA6, 0X88, 0X88, 0X88, 0X78, 0X87, 0X86,   //2033      
    0XA5, 0XB3, 0XA5, 0XA5, 0XA6, 0XA6, 0X88, 0X78, 0X88, 0X78, 0X87, 0X87,   //2034      
    0XA5, 0XB4, 0X96, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //2035      
    0X95, 0XB4, 0XA5, 0XB4, 0XA5, 0XA6, 0X97, 0X87, 0X87, 0X78, 0X87, 0X96,   //2036      
    0XA5, 0XC3, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X86,   //2037      
    0XA5, 0XB3, 0XA5, 0XA5, 0XA6, 0XA6, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //2038      
    0XA5, 0XB4, 0X96, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //2039      
    0X95, 0XB4, 0XA5, 0XB4, 0XA5, 0XA6, 0X97, 0X87, 0X87, 0X78, 0X87, 0X96,   //2040      
    0XA5, 0XC3, 0XA5, 0XB5, 0XA5, 0XA6, 0X87, 0X88, 0X87, 0X78, 0X87, 0X86,   //2041      
    0XA5, 0XB3, 0XA5, 0XB5, 0XA6, 0XA6, 0X88, 0X88, 0X88, 0X78, 0X87, 0X87,   //2042      
    0XA5, 0XB4, 0X96, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //2043      
    0X95, 0XB4, 0XA5, 0XB4, 0XA5, 0XA6, 0X97, 0X87, 0X87, 0X88, 0X87, 0X96,   //2044      
    0XA5, 0XC3, 0XA5, 0XB4, 0XA5, 0XA6, 0X87, 0X88, 0X87, 0X78, 0X87, 0X86,   //2045      
    0XA5, 0XB3, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X88, 0X78, 0X87, 0X87,   //2046      
    0XA5, 0XB4, 0X96, 0XA5, 0XA6, 0X96, 0X88, 0X88, 0X78, 0X78, 0X87, 0X87,   //2047      
    0X95, 0XB4, 0XA5, 0XB4, 0XA5, 0XA5, 0X97, 0X87, 0X87, 0X88, 0X86, 0X96,   //2048      
    0XA4, 0XC3, 0XA5, 0XA5, 0XA5, 0XA6, 0X97, 0X87, 0X87, 0X78, 0X87, 0X86,   //2049      
    0XA5, 0XC3, 0XA5, 0XB5, 0XA6, 0XA6, 0X87, 0X88, 0X78, 0X78, 0X87, 0X87    //2050      
};    

//公历每月前面的天数
static int wMonthAdd[] = {0,31,59,90,120,151,181,212,243,273,304,334};

static int wNongliData[] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
	,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
	,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
	,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
	,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
	,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
	,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
	,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
	,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
	,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};

@implementation CnCalendar

+ (NSDate *)getLunarDate:(NSDate *)date {
	if (nil == date) {
		return nil;
	}
	
    int wCurYear, wCurMonth, wCurDay;
    int nTheDate, nIsEnd, m, k, n, i, nBit;
	
    //取当前公历年、月、日
	NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
	NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    wCurYear = [components year];
    wCurMonth = [components month];
    wCurDay = [components day];
	
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
	NSInteger wmIndex = wCurMonth - 1;
	if (wmIndex<0 || wmIndex>11) {
		return nil;
	}
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wmIndex] - 38;
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;	
	
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1) {
		if (m<0 || m>99) {
			return nil;
		}
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0) {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            nBit = nBit % 2;
            if (nTheDate <= (29 + nBit)) {
                nIsEnd = 1;
                break;
            }
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
	
	if (m<0 || m>99) {
		return nil;
	}
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
	
	if (wCurMonth < 1){
        wCurMonth = -wCurMonth;
    }
	
	[components setYear:wCurYear];
	[components setMonth:wCurMonth];
	[components setDay:wCurDay];
	NSDate *lunarDate = [[NSCalendar currentCalendar] dateFromComponents:components];
	return lunarDate;
}

//农历转换函数
+ (NSString *)getLunarDay:(NSDate *)date{
	if (nil == date) {
		return nil;
	}
	
    //农历日期名
    NSArray *cDayName = [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
						 @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
						 @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
	if ([cDayName count] == 0) {
		return nil;
	}
    //农历月份名
    NSArray *cMonName = [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
	if ([cMonName count] == 0) {
		return nil;
	}

    NSInteger wCurYear,wCurMonth,wCurDay;
    NSInteger nTheDate,nIsEnd,m,k,n,i,nBit;
	
    //取当前公历年、月、日
	NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
	NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    wCurYear = [components year];
    wCurMonth = [components month];
    wCurDay = [components day];
	
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
	NSInteger wmIndex = wCurMonth - 1;
	if (wmIndex<0 || wmIndex>11) {
		return nil;
	}
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wmIndex] - 38;
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;	
	
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1) {
		if (m<0 || m>99) {
			return nil;
		}
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0) {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            nBit = nBit % 2;
            if (nTheDate <= (29 + nBit)) {
                nIsEnd = 1;
                break;
            }
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
	
	if (m<0 || m>99) {
		return nil;
	}
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
	
    //生成农历月、日
	NSString *szNongliDay;
	if (wCurMonth<-12 || wCurMonth>12) {
		return nil;
	}
    if (wCurMonth < 1){
        szNongliDay = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]]; 
    }
    else{
        szNongliDay = (NSString *)[cMonName objectAtIndex:wCurMonth]; 
    }
	
	if (wCurDay<0 || wCurDay>30) {
		return nil;
	}
    NSString *lunarDay = [NSString stringWithFormat:@"%@月%@",szNongliDay,(NSString*)[cDayName objectAtIndex:wCurDay]];
	return lunarDay;
}

//只返回初一，初二。。。
+ (NSString *)getLunarOnlyDay:(NSDate *)date
{
	if (nil == date) {
		return nil;
	}
	
    //农历日期名
    NSArray *cDayName = [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
						 @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
						 @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
	if ([cDayName count] == 0) {
		return nil;
	}
    //农历月份名
    NSArray *cMonName = [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
	if ([cMonName count] == 0) {
		return nil;
	}
    
    int wCurYear,wCurMonth,wCurDay;
    int nTheDate,nIsEnd,m,k,n,i,nBit;
	
    //取当前公历年、月、日
	NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
	NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    wCurYear = [components year];
    wCurMonth = [components month];
    wCurDay = [components day];
	
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
	NSInteger wmIndex = wCurMonth - 1;
	if (wmIndex<0 || wmIndex>11) {
		return nil;
	}
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wmIndex] - 38;
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
	
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1) {
		if (m<0 || m>99) {
			return nil;
		}
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0) {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            nBit = nBit % 2;
            if (nTheDate <= (29 + nBit)) {
                nIsEnd = 1;
                break;
            }
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
	
	if (m<0 || m>99) {
		return nil;
	}
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
	
    //生成农历月、日
	NSString *szNongliDay;
	if (wCurMonth<-12 || wCurMonth>12) {
		return nil;
	}
    if (wCurMonth < 1){
        szNongliDay = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }
    else{
        szNongliDay = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
	
	if (wCurDay<0 || wCurDay>30) {
		return nil;
	}
    
    if ([(NSString*)[cDayName objectAtIndex:wCurDay] isEqualToString:@"初一"]) {
        return [NSString stringWithFormat:@"%@月", szNongliDay];
    }
    
	return (NSString*)[cDayName objectAtIndex:wCurDay];
}

+ (NSString *)getLunarSpecialDay:(NSDate *)date {
	if (nil == date) {
		return nil;
	}
	
	NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
	NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
	NSInteger iYear = [components year];
	NSInteger iMonth = [components month];
	NSInteger iDay = [components day];
	
    NSArray *chineseDays=[NSArray arrayWithObjects:  
                          @"小寒", @"大寒", @"立春", @"雨水", @"惊蛰", @"春分", 
                          @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至", 
                          @"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分", 
                          @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至", nil]; 
	
    int array_index = (iYear - START_YEAR)*12+iMonth -1 ;  
	
	if (array_index<0 || array_index>=1500) {
		return nil;
	}
    int64_t flag = gLunarHolDay[array_index];     
    int64_t day;  
	
    if(iDay <15)     
        day= 15 - ((flag>>4)&0x0f);      
    else      
        day = ((flag)&0x0f)+15;  
    int index = -1;  
    if(iDay == day){   
        index = (iMonth-1) *2 + (iDay>15? 1: 0);   
    }  
    if ( index >= 0  && index < [chineseDays count] ) {  
        return [chineseDays objectAtIndex:index];  
    } else {  
        return nil;  
    }  
}

+ (NSString *)getLunarHolidayDay:(NSDate *)date {
	if (nil == date) {
		return nil;
	}
	
	NSString *resultStr = nil;
    NSTimeInterval timeInterval_day = (float)(60*60*24);  
    NSDate *nextDay_date = [[NSDate alloc] initWithTimeInterval:timeInterval_day sinceDate:date];
    NSDate *nextDayLunarDate = [self getLunarDate:nextDay_date];
	NSCalendar *localCalendar = [NSCalendar currentCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *localComp = [localCalendar components:unitFlags fromDate:nextDayLunarDate];
    if ( 1 == localComp.month && 1 == localComp.day ) {  
		resultStr = @"除夕";
    } else {
		NSDictionary *chineseHoliday = [NSDictionary dictionaryWithObjectsAndKeys:  
										@"春节", @"1-1",  @"元宵", @"1-15",  @"端午", @"5-5",  @"七夕", @"7-7",  
										@"中元", @"7-15", @"中秋", @"8-15",  @"重阳", @"9-9",  @"腊八", @"12-8",  
										@"小年", @"12-24",  nil];  
		localComp = [localCalendar components:unitFlags fromDate:[self getLunarDate:date]];  
		NSString *key_str = [NSString stringWithFormat:@"%d-%d",localComp.month,localComp.day]; 
		resultStr = [chineseHoliday objectForKey:key_str];
	}
	
    [nextDay_date release];
	return resultStr;
}  

+ (NSString *)getSolarHolidayDay:(NSDate *)date {
	if (nil == date) {
		return nil;
	}
	
	NSString *resultStr;
	
	NSDictionary *holidays = [NSDictionary dictionaryWithObjectsAndKeys:  
						@"元旦", @"1-1", @"情人节", @"2-14", @"妇女节", @"3-8", @"植树节", @"3-12", 
						@"消费者权益日", @"3-15", @"愚人节", @"4-1", @"清明节", @"4-5", @"劳动节", @"5-1", 
						@"青年节", @"5-4", @"儿童节", @"6-1", @"建党节", @"7-1", @"建军节", @"8-1", 
						@"教师节", @"9-10", @"国庆节", @"10-1", @"平安夜", @"12-24", @"圣诞节", @"12-25", nil];  
	NSCalendar *localCalendar = [NSCalendar currentCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit 
										| NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit;
	NSDateComponents *localComp = [localCalendar components:unitFlags fromDate:date];
	NSString *key_str = [NSString stringWithFormat:@"%d-%d",localComp.month,localComp.day]; 
	resultStr = [holidays objectForKey:key_str];
	if (nil == resultStr) {
		if ([localComp month]==5 && [localComp weekdayOrdinal]==2 && [localComp weekday]==1) {
			resultStr = @"母亲节";
		} else if ([localComp month]==6 && [localComp weekdayOrdinal]==3 && [localComp weekday]==1) {
			resultStr = @"父亲节";
		}
	}

	return resultStr;
}

+ (NSString *)nextLunarSpecialDaySinceNow {
    NSDate *curDayDate = [NSDate date];
	NSString *resultStr = [self nextLunarSpecialDaySinceDate:curDayDate];
	return resultStr;
}

+ (NSInteger)nextLunarSpecialIntervalDaySinceNow {
	NSDate *curDayDate = [NSDate date];
	NSInteger count = [self nextLunarSpecialIntervalDaySinceDate:curDayDate];
	return count;
}

+ (NSString *)nextLunarSpecialDaySinceDate:(NSDate *)date {
	if (nil == date) {
		return nil;
	}
	
	NSDate *curDayDate = date;
	NSInteger count = [self nextLunarSpecialIntervalDaySinceDate:curDayDate];
	NSDate *nextSpecialDayDate;
	if (count == 0) {
		nextSpecialDayDate = curDayDate;
	}
    if (count > 0) {
		NSTimeInterval timeInterval = (float)(60*60*24*count);
		nextSpecialDayDate = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:curDayDate];
	}
	
	NSString *specialDayName = [self getLunarSpecialDay:nextSpecialDayDate];	
	NSString *resultStr;
	if (nil==specialDayName||[specialDayName length]==0){
		resultStr = @"";
	}else if (count == 0) {
		resultStr = [NSString stringWithFormat:@"今日:%@", specialDayName];
	} else if(count > 0) {
		resultStr = [NSString stringWithFormat:@"距%@还有%d日", specialDayName, count];
	} else {
		resultStr = @"";
	}
	
	return resultStr;
}

+ (NSInteger)nextLunarSpecialIntervalDaySinceDate:(NSDate *)date {
	if (nil == date) {
		return nil;
	}
	
	NSInteger count=0;
	NSTimeInterval timeIntervalDay = (float)(60*60*24);
    NSDate *curDayDate = date;
	NSString *specialDay = [self getLunarSpecialDay:curDayDate];
	if (nil != specialDay) {
		return count;
	}
	
	count++;
	NSDate *nextDate = [[[NSDate alloc] initWithTimeInterval:timeIntervalDay sinceDate:curDayDate] autorelease];
	specialDay = [self getLunarSpecialDay:nextDate];
	while (nil==specialDay && count<=20) {
		count++;
		nextDate = [[[NSDate alloc] initWithTimeInterval:timeIntervalDay sinceDate:nextDate] autorelease];
		specialDay = [self getLunarSpecialDay:nextDate];
	}
	if (count > 20) {
		count = -1;
	}
	
	return count;
}

+ (NSString *)nextLunarHolidaySinceNow {
    NSDate *curDayDate = [NSDate date];
	NSString *resultStr = [self nextLunarHolidaySinceDate:curDayDate];
	return resultStr;
}

+ (NSString *)nextLunarHolidaySinceDate:(NSDate *)date {
	if (nil == date) {
		return nil;
	}
	
	NSDate *curDayDate = date;
	NSInteger count = [self nextLunarHolidayIntervalDaySinceDate:curDayDate];
	NSDate *nextSpecialDayDate;
	if (count == 0) {
		nextSpecialDayDate = curDayDate;
	}
    if (count > 0) {
		NSTimeInterval timeInterval = (float)(60*60*24*count);
		nextSpecialDayDate = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:curDayDate];
	}
	
	NSString *specialDayName = [self getLunarHolidayDay:nextSpecialDayDate];
	NSString *resultStr;
	if (nil==specialDayName||[specialDayName length]==0){
		resultStr = @"";
	}else if (count == 0) {
		resultStr = [NSString stringWithFormat:@"今日:%@", specialDayName];
	} else if(count > 0) {
		resultStr = [NSString stringWithFormat:@"距%@还有%d日", specialDayName, count];
	} else {
		resultStr = @"";
	}
	
	return resultStr;
}

+ (NSInteger)nextLunarHolidayIntervalDaySinceDate:(NSDate *)date {
	if (nil == date) {
		return nil;
	}
	
	NSInteger count=0;
	NSTimeInterval timeIntervalDay = (float)(60*60*24);
    NSDate *curDayDate = date;
	NSString *specialDay = [self getLunarHolidayDay:curDayDate];
	if (nil != specialDay) {
		return count;
	}
	
	count++;
	NSDate *nextDate = [[[NSDate alloc] initWithTimeInterval:timeIntervalDay sinceDate:curDayDate] autorelease];
	specialDay = [self getLunarHolidayDay:nextDate];
	while (nil==specialDay && count<=366) {
		count++;
		nextDate = [[[NSDate alloc] initWithTimeInterval:timeIntervalDay sinceDate:nextDate] autorelease];
		specialDay = [self getLunarHolidayDay:nextDate];
	}
	if (count > 366) {
		count = -1;
	}
	
	return count;
}

+ (NSString *)nextSolarHolidaySinceNow {
    NSDate *curDayDate = [NSDate date];
	NSString *resultStr = [self nextSolarHolidaySinceDate:curDayDate];
	return resultStr;
}

+ (NSString *)nextSolarHolidaySinceDate:(NSDate *)date {
	if (nil == date) {
		return nil;
	}
	
	NSDate *curDayDate = date;
	NSInteger count = [self nextSolarHolidayIntervalDaySinceDate:curDayDate];
	NSDate *nextSpecialDayDate;
	if (count == 0) {
		nextSpecialDayDate = curDayDate;
	}
    if (count > 0) {
		NSTimeInterval timeInterval = (float)(60*60*24*count);
		nextSpecialDayDate = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:curDayDate];
	}
	
	NSString *specialDayName = [self getSolarHolidayDay:nextSpecialDayDate];
	NSString *resultStr;
	if (nil==specialDayName||[specialDayName length]==0){
		resultStr = @"";
	}else if (count == 0) {
		resultStr = [NSString stringWithFormat:@"今日:%@", specialDayName];
	} else if(count > 0) {
		resultStr = [NSString stringWithFormat:@"距%@还有%d日", specialDayName, count];
	} else {
		resultStr = @"";
	}
	
	return resultStr;
}

+ (NSInteger)nextSolarHolidayIntervalDaySinceDate:(NSDate *)date {
	if (nil == date) {
		return nil;
	}
	
	NSInteger count=0;
	NSTimeInterval timeIntervalDay = (float)(60*60*24);
    NSDate *curDayDate = date;
	NSString *specialDay = [self getSolarHolidayDay:curDayDate];
	if (nil != specialDay) {
		return count;
	}
	
	count++;
	NSDate *nextDate = [[[NSDate alloc] initWithTimeInterval:timeIntervalDay sinceDate:curDayDate] autorelease];
	specialDay = [self getSolarHolidayDay:nextDate];
	while (nil==specialDay && count<=366) {
		count++;
		nextDate = [[[NSDate alloc] initWithTimeInterval:timeIntervalDay sinceDate:nextDate] autorelease];
		specialDay = [self getSolarHolidayDay:nextDate];
	}
	if (count > 366) {
		count = -1;
	}
	
	return count;
}

+ (NSString *)getWeekday:(NSDate *)date {
	if (nil == date) {
		return nil;
	}
	
	NSArray *weekdays = [[NSArray alloc] initWithObjects:@"星期日",@"星期一", @"星期二", @"星期三", 
						 @"星期四", @"星期五", @"星期六", nil];
	if ([weekdays count] == 0) {
		return nil;
	}
	
	NSCalendar *localCalendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags = NSWeekdayCalendarUnit;
	NSDateComponents *localComp = [localCalendar components:unitFlags fromDate:date];
	
	NSInteger wkdIndex = [localComp weekday]-1;
	if (wkdIndex<0 || wkdIndex>6) {
		return nil;
	}
	NSString *resultStr = [weekdays objectAtIndex:wkdIndex];
	return resultStr;
}

+ (NSString *)getAmPm:(NSDate *)date {
	NSCalendar *localCalendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags = NSHourCalendarUnit;
	NSDateComponents *localComp = [localCalendar components:unitFlags fromDate:date];
	return ([localComp hour] < 12 ? @"上午" : @"下午");
}
@end
