#!/bin/bash

MICROPYTHON="${MICROPYTHON:-${PWD}/../build/unix/micropython}"
PYOPT="${PYOPT:-0}"
TREZOR_SRC=$(cd "${PWD}/../src/"; pwd)

source ../trezor_cmd.sh

# remove flash before run to prevent inconsistent states
mv "${TREZOR_PROFILE_DIR}/trezor.flash" "${TREZOR_PROFILE_DIR}/trezor.flash.bkp"

# run emulator
cd "${TREZOR_SRC}"
echo "Starting emulator: $MICROPYTHON $ARGS ${MAIN}"
$MICROPYTHON $ARGS "${MAIN}" &> "${TREZOR_LOGFILE}" &
upy_pid=$!
sleep 1

# run tests
cd ..
error=0
if ! pytest "$@"; then
    error=1
fi
kill $upy_pid
exit $error
