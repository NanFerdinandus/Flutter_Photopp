public class Photo
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public User UploadedBy { get; set; }
        public int Rating { get; set; }

        public void AddRating(int rating)
        {

        }
    }