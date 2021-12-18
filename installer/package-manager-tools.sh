#!/bin/zsh
SCRIPT_DIR="`dirname $0`"

# Includes ###############################################
source "$SCRIPT_DIR/installer-tools.sh"

# Globals ################################################
# Package manager
PackageManager=''


# Functions ##############################################
function get_package_manager()  # Set the global PackageManager to the package manager of the system.
{
    for p in {yay,pacman,apt,apt-get}
    do
        if silent_call $p --version; then
            PackageManager=$p
            print_info "Using '$PackageManager' as the package manager."
            if [[ $PackageManager == 'pacman' ]]; then
                print_note "A lot of packages on Arch are from the AUR. It is simpler to use an AUR helper like yay."
                if yes_no_prompt "Do you want to install yay?"; then
                    aur_install 'yay' '/tmp/build'
                else
                    print_note "Will use pacman with limited packages."
                fi
            fi
            return $EXIT_STATUS_SUCCESS
        fi
    done

    print_error "Could not find a valid package manager."
    return $EXIT_STATUS_FAILURE
}

function aur_install()
{
    package=$1
    build_dir=$2
    cwd_backup=`pwd`

    if yes_no_prompt "Install '$package' from the AUR in build dir '$build_dir'?"; then
        verbose_run mkdir -p $build_dir
        verbose_run git clone "https://aur.archlinux.org/$package.git" "$build_dir/$package"
        if verbose_run cd "$build_dir/$package"; then
            verbose_run makepkg -sirc
        else
            print_error "Failed to clone and cd into package build directory."
        fi
        verbose_run cd $cwd_backup

        print_note "'$package' was installed from '$build_dir/$package'. If there is no intention to update the package, '$build_dir/$package' can be safely removed."
        print_note "If you wish to update this paclage, 'cd' into '$build_dir/$package', run 'git pull', and then 'makepkg -sirc'."
        print_done "Installing '$package'."
    else
        print_warning "AUR installation of package '$package' in build dir '$build_dir' was cancled."
    fi
}

function install_packages()
{
    packages=${@:1}
    print_info "Trying to install the following packages: {$packages}"

    case $PackageManager in
        "yay")
            verbose_run xargs -o $PackageManager -S --needed --color=always <<< $packages
            ;;
        "pacman")
            verbose_run sudo xargs -o $PackageManager -S --needed --color=always <<< $packages
            ;;
        "apt"|"apt-get")
            verbose_run sudo xargs -o $PackageManager install <<< $packages
            ;;
        "")
            print_info "PackageManager is not initialized, initializing..."
            if get_package_manager; then
                install_packages $packages
                return
            else
                print_error "Could not find a package manager."
                return $EXIT_STATUS_FAILURE
            fi
            ;;
        *)
            print_error "'$PackageManager' is not a valid package manager. exiting..."
            return $EXIT_STATUS_FAILURE
            ;;
    esac

    return_status=$?
    if [[ $return_status != $EXIT_STATUS_SUCCESS ]]; then
        print_error "Failed to install {$packages}. exit_status=$return_status"
    fi
    return $return_status
}

function install_pip_packages()
{
    packages=${@:1}
    print_info "Trying to install the following pip packages: {$packages}"

    verbose_run xargs -o sudo pip install <<< $packages

    return_status=$?
    if [[ $return_status != $EXIT_STATUS_SUCCESS ]]; then
        print_error "Failed to install {$packages} via pip. exit_status=$return_status"
    fi
    return $return_status
}

function install_npm_packages()
{
    packages=${@:1}
    print_info "Trying to install the following npm packages: {$packages}"

    verbose_run xargs -o sudo npm -g install <<< $packages

    return_status=$?
    if [[ $return_status != $EXIT_STATUS_SUCCESS ]]; then
        print_error "Failed to install {$packages} via npm. exit_status=$return_status"
    fi
    return $return_status
}

function update_packages()
{
    print_info "Trying to install the following packages: {$packages}"

    case $PackageManager in
        "yay")
            verbose_run $PackageManager -Syu --needed --color=always --noconfirm
            ;;
        "pacman")
            verbose_run sudo $PackageManager -Syu --needed --color=always --noconfirm
            ;;
        "apt"|"apt-get")
            verbose_run sudo $PackageManager update
            verbose_run sudo $PackageManager upgrade
            ;;
        "")
            print_info "PackageManager is not initialized, initializing..."
            if get_package_manager; then
                update_packages
                return
            else
                print_error "Could not find a package manager."
                return $EXIT_STATUS_FAILURE
            fi
            ;;
        *)
            print_error "'$PackageManager' is not a valid package manager. exiting..."
            return $EXIT_STATUS_FAILURE
            ;;
    esac

    return_status=$?
    if [[ $return_status != $EXIT_STATUS_SUCCESS ]]; then
        print_error "Failed to update. exit_status=$return_status"
    fi
    return $return_status
}

