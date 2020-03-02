Creating a Subaccount in Amazon Web Services
============================================

Anytime we host resources for a client within the Caktus Amazon Web Services (AWS) account, we set up a sub-account and put the resources there. Some of the advantages of doing this compared to putting a client's resources in our main account are:

* It keeps things separate from Caktus resources
* We can limit which users can access it
* It makes it easy to clean up later

When we finish setting this up, the Caktus AWS users of our choice are able
to log into the Caktus AWS account with their IAM (Identity and Access Management) user there, temporarily switch to the sub-account to do some work, then switch back to the Caktus account when they are done.

In the following example of creating a sub-account, the account ID of the master account will be 111111111111, and the account ID of the sub-account will be 123456789012.

Let's start.

#. Pick an email address for the sub-account owner. This will be the
   email address on the "root user" within the sub-account, which will have
   complete control to administer the sub-account.  (More on this below.)

#. Log in to the master account in the AWS console.

#. Go to the `Organizations page
   <https://console.aws.amazon.com/organizations/home?#/accounts>`_.

#. Click "Add account."

#. Click "Create account."

#. Enter anything reasonable for the Full name.

#. Enter the email address we chose above.

#. **IMPORTANT:** Fill in the "IAM Role Name" with a meaningful name. This will typically be displayed when users are switching to this account, so it should clearly identify this sub-account.  For example, you might start with the account's "Full name" and remove the spaces.

#. Click "Create."

#. If all goes well, this takes us back to the list of accounts. If the new one looks grayed out, it's not quite done being created; wait a little and refresh the list until it looks normal.

#. Log out of the master account.

Think carefully about the email address to use for the sub-account. This email address *not only* has to be unique among existing accounts, it *also*  can never again be used to create an account, even after this account is closed. *EVER*.

I like to use the email address of the internal email list we have set up for
the client project, just making sure first that it's been set up to accept email
from external sources like AWS.

Another option might be to use the "+" in an email address, e.g. `yourusername+testaccountname@youremail.domain`.

If you accidentally use an email address that you didn't mean to, you might be able to
`change the email address <https://aws.amazon.com/premiumsupport/knowledge-center/change-email-address/>`_
on the account *before* you close it, and thus get it back.


Now, we need to set a password for the new root account, using the
password reset mechanism:

#. Go to `the Amazon console page <https://aws.amazon.com/console/>`_.

#. Click "Sign in to the Console" in the top right.

#. If the first field shown is "Account ID or alias," click the link below
   in small print "Sign-in using root account credentials."

#. Enter the sub-account's email address from above and click "Next."

#. Click the link "Forgot password?"

#. Complete the CAPTCHA challenge and click "Send email."

#. The password reset should arrive almost immediately in the mailbox of that email address. Follow the link and set a strong password on the account.

Now we'll sign into the new account using the root account and set up a role that we can use to let users switch to this account:

#. Sign in to the AWS console, "using root account credentials,"
   using the sub-account email above and the password we just set.

#. Go to IAM, Roles.

#. Search for the role with the name you chose earlier and click on it.

#. Copy the Role ARN and save it. (It will look like "arn:aws:iam::123456789012:role/test-role".)

#. Copy the link labeled "Give this link to users who can switch roles in the console" and save it.

#. In the Permissions tab, review the permissions. By default, when your users switch to the sub-account, they'll have the role "AdministratorAccess," which will be shown here when you start. If you want to change that, do it now.

#. In the Tags tab, enter any desired tags for the role and save the new tags.

#. Log out.

Now, back in the master account, we'll arrange for selected users to be able to use that role to switch to the sub-account.
We'll be pasting this policy document::

  {
          "Version": "2012-10-17",
          "Statement": {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::123456789012:role/test-role"
          }
        }

#. Log into the master account again.

#. Go to IAM, Groups, "Create New Group."

#. Give the group a name like "NewAccountNameAdmins" or "AccessNewAccountName," and click "Next Step."

#. On the Attach Policy page, click "Next Step." (We want to attach an inline
   policy, but we can't do that here; we have to do it after the group exists, so we skip this page.)

#. Click "Create Group."

#. We should see the groups. Click on the new one.

#. Under the Permissions tab, click "Inline Policies," then "click here" (where
   it says to click new policies, click here).

#. Change the selection from Policy Generator to "Custom Policy," then click "Select."

#. The policy name has to be simple. "SwitchToAccountName" might be good.

#. Paste the policy document above into the Policy Document field, then *change the value*
   of "Resource" to the "Role ARN" that you saved earlier.

#. Click "Apply Policy." Members of this group will now be able to assume that role, which lets them do whatever they can in the sub-account with the permissions of that role.

Finally, add some users to the group. These users will be able to switch to
the new account.

#. Change to the group's "Users" tab, then click "Add Users to Group."

#. Select some users (including yourself), then click "Add Users."

That should do it.

Switching to a Sub-account
--------------------------

Now let the users know they can administer the new account
by:

#. Log into master account using their username there.

#. Go to the link we saved above under "Give this link to..." and follow
   the instructions.

**WARNING:** If you use Lastpass, it has a tendency to change values in the fields after a user
has followed the link. It might be necessary to temporarily turn off the Lastpass
browser extension, or find some option to stop it doing that, in order to get
this to work.

Granting API Access to the Sub-account
----------------------------------------------------

To access the sub-account using AWS APIs, create api-only users in the sub-account, not the master account. Otherwise this is just like giving API access to any other account.

DELETING a Sub-account
----------------------

At some point, we might not need the sub-account anymore. Deleting a sub-account
works like this:

#. Log in to the sub-account using the root user.

#. Go to `https://console.aws.amazon.com/billing/home?#/account <https://console.aws.amazon.com/billing/home?#/account>`_ (use that link, I have not found another way to get to that page).

#. Scroll all the way down to the bottom.

#. Under "Close Account", select all the checkboxes, then click "Close Account."

Conclusion
---------------

Creating sub-accounts is a good way to isolate a set of AWS resources if you want to control who has access to them and make it simple to clean them all up later. It may take you 20-30 minutes to do this the first few times, but it'll save you a lot more time later.
