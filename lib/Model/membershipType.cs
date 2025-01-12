public abstract class MembershipType
{
    public string TypeName { get; set; }
    public abstract void PerformMembershipAction(User user);
}

public class User : MembershipType
{
    public override void PerformMembershipAction(User user)
    {
        
    }
}

public class Supermember : MembershipType
{
    public override void PerformMembershipAction(User user)
    {
        user.Points += 5; 
    }
}

public class Admin : MembershipType
{
    public override void PerformMembershipAction(User user)
    {

    }
}
