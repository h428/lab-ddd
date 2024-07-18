package com.lab.domain.entity;

import com.lab.common.Aggregate;
import com.lab.types.common.Name;
import com.lab.types.user.Avatar;
import com.lab.types.user.BaseUserId;
import com.lab.types.user.UserName;
import com.lab.types.user.UserPass;

public class BaseUser implements Aggregate<BaseUserId> {

    private BaseUserId baseUserId;

    private UserName userName;

    private UserPass userPass;

    private Name name;

    private Avatar avatar;

    public int register() {
        return 0;
    }

    public boolean login() {
        return false;
    }




}
