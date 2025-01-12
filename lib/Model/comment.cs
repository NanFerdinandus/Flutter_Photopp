public class Comment
    {
        public int Id { get; set; }
        public int PhotoId { get; set; }
        public string Content { get; set; }
        public User CreatedBy { get; set; }

        public void DeleteComment()
        {
        
        }
    }