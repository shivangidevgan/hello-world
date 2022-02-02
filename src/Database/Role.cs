using System;

namespace dotnet-core-hello-world
{
    public class Role
    {
        private Role()
        {

        }

        public Role(string name, string description, bool isActive = true)
        {
            this.Name = name;
            this.Description = description;
            this.IsActive = isActive;
        }

        public Guid Id { get; private set; }
        public string Name { get; private set; }
        public string Description { get; private set; }
        public bool IsActive { get; private set; }
    }
}