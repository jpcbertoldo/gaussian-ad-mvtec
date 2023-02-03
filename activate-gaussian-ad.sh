function setup_conda() {

    local INIT_CONDA_FPATH=${HOME}/init-conda-bash

    if [ -f ${INIT_CONDA_FPATH} ]; then
        source ${INIT_CONDA_FPATH}

    elif ! command -v conda > /dev/null; then
        echo "[error] conda is not found!"
        exit 1
    fi

    # src: https://stackoverflow.com/a/56155771/9582881
    # i have to do this because otherwise `conda activate` fails
    eval "$(conda shell.bash hook)"
    echo "[debug] conda=$(which conda)"
}

echo "setting up conda"
setup_conda

# ==============================================================================

function get_this_script_dir() {
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    SCRIPT_DIR=$(realpath $SCRIPT_DIR)
}

get_this_script_dir
echo "[debug] SCRIPT_DIR=${SCRIPT_DIR}"

# REPO_DIR="${SCRIPT_DIR}/src/gaussian-ad-mvtec"           # repo dir
REPO_DIR="${SCRIPT_DIR}"           # repo dir
echo "[debug] REPO_DIR=${REPO_DIR}"

cd ${REPO_DIR}
echo "[debug] pwd=$(pwd)"


# ==============================================================================


find_in_conda_env(){
    # src
    # https://stackoverflow.com/a/70598193/9582881
    conda env list | grep "${@}" >/dev/null 2>/dev/null
}


CONDA_ENV_NAME="gaussian-ad-mvtec"                      # conda env name


if ! find_in_conda_env ${CONDA_ENV_NAME}; then
    echo "conda env not found, creating new one"
    conda env create --file environment.yml
else 
    echo "conda env found!"
fi

conda activate ${CONDA_ENV_NAME}
echo "[debug] conda env activated"

# ==============================================================================

# other instructions from the README

export MVTECPATH="/cuda/data-2/jcasagrandebertoldo/datasets/MVTec"
echo "[debug] MVTECPATH=${MVTECPATH}"

echo "run scripts with: python -m src.scripts.table1"