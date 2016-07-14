#!/usr/bin/env bash

usage()
{
    echo "Builds the NuGet packages from the binaries that were built in the Build product binaries step."
    echo "Usage: build-packages -BuildArch -BuildType"
    echo "arch can be x64, x86, arm, arm64 (default is x64)"
    echo "configuration can be release, checked, debug (default is debug)"
    echo
    exit 1
}

__ProjectRoot="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

unprocessedBuildArgs=

while :; do
    if [ $# -le 0 ]; then
        break
    fi

	opt="$1"
    case $opt in
        -\?|-h|--help)
        usage
        exit 1
        ;;
        *)
        unprocessedBuildArgs="$unprocessedBuildArgs $1"
    esac
    shift
done

echo "$__ProjectRoot/run.sh build-packages -Project=$__ProjectRoot/src/.nuget/Microsoft.NETCore.Runtime.CoreClr/Microsoft.NETCore.Runtime.CoreCLR.builds -DistroRid $unprocessedBuildArgs"
$__ProjectRoot/run.sh build-packages -Project=$__ProjectRoot/src/.nuget/Microsoft.NETCore.Runtime.CoreClr/Microsoft.NETCore.Runtime.CoreCLR.builds -DistroRid $unprocessedBuildArgs
if [ $? -ne 0 ]
then
    echo "ERROR: An error occurred while syncing packages; See build-packages.log for more details."
    exit 1
fi

echo "$__ProjectRoot/run.sh build-packages -Project=$__ProjectRoot/src/.nuget/Microsoft.NETCore.Jit/Microsoft.NETCore.Jit.builds -DistroRid $unprocessedBuildArgs"
$__ProjectRoot/run.sh build-packages -Project=$__ProjectRoot/src/.nuget/Microsoft.NETCore.Jit/Microsoft.NETCore.Jit.builds -DistroRid $unprocessedBuildArgs
if [ $? -ne 0 ]
then
    echo "ERROR: An error occurred while syncing packages; See build-packages.log for more details."
    exit 1
fi

echo "$__ProjectRoot/run.sh build-packages -Project=$__ProjectRoot/src/.nuget/Microsoft.NETCore.ILAsm/Microsoft.NETCore.ILAsm.builds -DistroRid $unprocessedBuildArgs"
$__ProjectRoot/run.sh build-packages -Project=$__ProjectRoot/src/.nuget/Microsoft.NETCore.ILAsm/Microsoft.NETCore.ILAsm.builds -DistroRid $unprocessedBuildArgs
if [ $? -ne 0 ]
then
    echo "ERROR: An error occurred while syncing packages; See build-packages.log for more details."
    exit 1
fi

echo "$__ProjectRoot/run.sh build-packages -Project=$__ProjectRoot/src/.nuget/Microsoft.NETCore.ILDAsm/Microsoft.NETCore.ILDAsm.builds -DistroRid $unprocessedBuildArgs"
$__ProjectRoot/run.sh build-packages -Project=$__ProjectRoot/src/.nuget/Microsoft.NETCore.ILDAsm/Microsoft.NETCore.ILDAsm.builds -DistroRid $unprocessedBuildArgs
if [ $? -ne 0 ]
then
    echo "ERROR: An error occurred while syncing packages; See build-packages.log for more details."
    exit 1
fi

echo "$__ProjectRoot/run.sh build-packages -Project=$__ProjectRoot/src/.nuget/Microsoft.TargetingPack.Private.CoreCLR/Microsoft.TargetingPack.Private.CoreCLR.pkgproj -DistroRid $unprocessedBuildArgs"
$__ProjectRoot/run.sh build-packages -Project=$__ProjectRoot/src/.nuget/Microsoft.TargetingPack.Private.CoreCLR/Microsoft.TargetingPack.Private.CoreCLR.pkgproj -DistroRid $unprocessedBuildArgs
if [ $? -ne 0 ]
then
    echo "ERROR: An error occurred while syncing packages; See build-packages.log for more details."
    exit 1
fi

echo "Done building packages."
exit 0
