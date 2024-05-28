
aws-login () {
    if [ $# -gt 0 ]; then
        local profile=$1
        shift
    else
        profile=$AWS_PROFILE
    fi

    test -n "$profile" || {
        echo "Usage aws-login [profile] [saml2aws options]"
        return 1
    }

    SAML2AWS_PASSWORD=`security find-generic-password -w -a isgwa3 -s isgwa3 | awk '{printf "%s", $1}'`
    export SAML2AWS_PASSWORD
    export SAML2AWS_IDP_ACCOUNT=$profile

    saml2aws login $@ --skip-prompt
    rcode=$?
    unset SAML2AWS_PASSWORD
    test $rcode -eq 0 || return $rcode

    export AWS_PROFILE=$profile

}

aws-console () {
    if [ -z "$AWS_PROFILE" ] || [ -z "$SAML2AWS_IDP_ACCOUNT" ]; then
        echo "Login with aws-login first"
        return 1
    fi

    aws-login || return 1

    saml2aws console
}
