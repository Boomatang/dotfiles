if hash ocm 2>/dev/null; then
    source $REPO_PATH/dotfiles/tools/osd/script.sh 
else
    note="ocm is not installed"
   
    ocm_create()
    {
        echo "$note"
    }

    osd_is_cluster_ready()
    {
        echo "$note"
    }

    osd_setup_credentials()
    {
        echo "$note"
    }

    osd_get_credentials()
    {
        echo "$note"
    }

    osd_get_cluster_id()
    {
        echo "$note"
    }

    osd_delete_addon_rhoam()
    {
        echo "$note"
    }

    osd_setup()
    {
        ocm_create
        osd_is_cluster_ready $1
        osd_setup_credentials $1
    }
fi