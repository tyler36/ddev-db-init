setup() {
  set -eu -o pipefail
  # Fail early if old ddev is installed
  ddev debug capabilities | grep multiple-dockerfiles || exit 3
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/testdb-init
  mkdir -p $TESTDIR
  export PROJNAME=ddev-db-init
  export DDEV_NON_INTERACTIVE=true

  ddev delete -Oy ${PROJNAME} || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  echo "<html><head></head><body>this is a test</body>" >index.html
  ddev start -y
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME}
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

# Confirm the basics services are running
healthchecks() {
  curl -s "https://${PROJNAME}.ddev.site" | grep "this is a test"
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart

  healthchecks
  # TODO: Confirm "testing" database exists
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get tyler36/ddev-db-init with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get tyler36/ddev-db-init
  ddev restart

  healthchecks
  # TODO: Confirm "testing" database exists
}

# @test "creates a second database in postgres:14" {
#   set -eu -o pipefail
#   cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
#   echo "# ddev get tyler36/ddev-db-init with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3

#   # Setup addon
#   ddev get ${DIR}
#   mkdir ${TESTDIR}/.ddev/db-init
#   cp ${DIR}/tests/testdata/create-database.sql  ${TESTDIR}/.ddev/db-init

#   # Set database to postgres:14
#   ddev config --database=postgres:14
#   ddev restart

#   healthchecks
#   # TODO: Confirm "testing" database exists
# }

# @test "creates a second database in mariadb:10.6" {
#   set -eu -o pipefail
#   cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
#   echo "# ddev get tyler36/ddev-db-init with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3

#   # Setup addon
#   ddev get ${DIR}
#   cp ${DIR}/tests/testdata/create-database.sql  ${TESTDIR}/.ddev/db-init

#   # Set database to mariadb:10.6
#   ddev config --database=mariadb:10.6
#   ddev restart

#   healthchecks
#   # TODO: Confirm "testing" database exists
# }

# @test "creates a second database in mysql:5.7" {
#   set -eu -o pipefail
#   cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
#   echo "# ddev get tyler36/ddev-db-init with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3

#   # Setup addon
#   ddev get ${DIR}
#   cp ${DIR}/tests/testdata/create-database.sql  ${TESTDIR}/.ddev/db-init

#   # Set database to mysql:5.7
#   ddev config --database=mysql:5.7
#   ddev restart

#   healthchecks
#   # TODO: Confirm "testing" database exists
# }
