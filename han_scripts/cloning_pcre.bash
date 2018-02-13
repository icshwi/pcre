#!/bin/bash
#
#  Copyright (c) 2018 - Present Jeong Han Lee
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
#
#   author  : Jeong Han Lee
#   email   : jeonghan.lee@gmail.com
#   date    : Wednesday, February 14 00:48:31 CET 2018
#   version : 0.0.1

declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_SCRIPTNAME=${0##*/}
declare -gr SC_TOP="$(dirname "$SC_SCRIPT")"
declare -gr SC_LOGDATE="$(date +%Y%b%d-%H%M-%S%Z)"

function pushd { builtin pushd "$@" > /dev/null; }
function popd  { builtin popd  "$@" > /dev/null; }


PCRE_URL="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre";
GIT_URL="https://github.com/jeonghanlee/pcre"
WGET_CMD="wget -c"
GIT_CMD="git clone"
FILE_PREFIX="pcre-"
FILE2_PREFIX="pcre2-"
FILE_SUFFIX="tar.gz"
REPO_PATH="${SC_TOP}/pcre"

declare -ga version_list=()
declare -ga version2_list=()

#version_list+=("8.38")
#version_list+=("8.39")
#version_list+=("8.40")
#version_list+=("8.41")

#version2_list+=("10.21")
#version2_list+=("10.22")
#version2_list+=("10.23")
#version2_list+=("10.30")
#version2_list+=("10.31")


function extract_file
{
    local version=$2
    local prefix=$1
    local filename=${prefix}${version}.${FILE_SUFFIX}
    pushd ${SC_TOP}
    ${WGET_CMD} ${PCRE_URL}/${filename}
    tar xf ${filename}
    scp -r ${prefix}${version}/* ${REPO_PATH}/
    popd
 
}

function do_git
{
    local version=$2
    local prefix=$1
    local filename=${prefix}${version}.${FILE_SUFFIX}
    pushd ${REPO_PATH}
    git st
    git add *
    git commit -m "clone ${PCRE_URL}/${filename}"
    git push
    git tag -a "${prefix}${version}" -m "PCRE ${version} from ${PCRE_URL}/${filename}"
    git push origin --tags
    popd
    
}
    


${GIT_CMD} ${GIT_URL} ${REPO_PATH}


# for rep in  ${version2_list[@]}; do
#     extract_file "${FILE2_PREFIX}" "${rep}"
#     do_git  "${FILE2_PREFIX}" "${rep}"
    
# done


### # pcre2-10.XX
# version=$1

# extract_file "${FILE2_PREFIX}" "${version}"
# do_git  "${FILE2_PREFIX}" "${version}"

#### pcre-8.XX
version=$1

extract_file "${FILE_PREFIX}" "${version}"
do_git  "${FILE_PREFIX}" "${version}"
