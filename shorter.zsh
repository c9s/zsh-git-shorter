


function _push_hg()
{

}

function _push_git()
{
    if [[ -n $3 ]] ; then
        git push $*
    else
        opts=()
        args=()
        for i in $@ ; do
            if [[ $i =~ '^-' ]]; then
                opts=(${opts[*]} $i)
            else 
                args=(${args[*]} $i)
            fi
        done
# # Trailing Substring Extraction
# echo ${arrayZ[@]:0}     # one two three four five five
# #                ^        All elements.
# 
# echo ${arrayZ[@]:1}     # two three four five five
# #                ^        All elements following element[0].

        # refs/heads/msg-ref
        remote=$1
        branch=$2

#          remote=${args[0]}
#          branch=${args[1]}
#          echo ${args[*]}
#          echo ${args[0]}
#          echo ${args[1]}
#          echo ${opts[*]}

        if [[ -z "$remote" ]] remote=origin 
        if [[ -z "$branch" ]] branch=$(cat .git/HEAD | sed -e 's/^.*heads\///')
        echo "* Pushing $branch to remote $remote"
        echo "     git push $remote $branch"
        git push $remote $branch || { 
            echo "Error"
            echo "* Available remotes"
            git remote -v
            echo "* Available branches"
            git branch -v
        }
    fi
}

function push()
{
    if [[ -e '.git' ]] ; then
        _push_git $*
        return
    elif [[ -e '.hg' ]] ; then
        _push_hg $*
        return
    fi
    push $*
    return
}

function add()
{
    if [[ -e '.git' ]] ; then
        git add $*
        return
    fi
    add $*
}

function ci() { 
    git status -uno
    if [[ -n "$*" ]] ; then
        echo "**** Sure to commit ? ****"
        read _answer_ && git commit -v -a -m "$*"
    else
        echo "**** Please Entry Message ****"
        cat > .commit-msg
        if [[ -e '.commit-msg' ]] 
            git commit -a --file .commit-msg && rm -v .commit-msg

    fi
}

function diff() {
    if [[ -n "$*" ]] ; then
        diff $*
    else
        git diff
    fi
}
