﻿//------------------------------------------------------------------------------
// <auto-generated>
//     Этот код создан по шаблону.
//
//     Изменения, вносимые в этот файл вручную, могут привести к непредвиденной работе приложения.
//     Изменения, вносимые в этот файл вручную, будут перезаписаны при повторном создании кода.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Travel_agency
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class Travel_agencyEntities : DbContext
    {
        public static Travel_agencyEntities _context { get; set; }

        public static Travel_agencyEntities GetContext()
        {
            if (_context == null)
            {
                _context = new Travel_agencyEntities();
            }
            return _context;
        }

        public Travel_agencyEntities()
            : base("name=Travel_agencyEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<sysdiagrams> sysdiagrams { get; set; }
        public virtual DbSet<Виды_жилья> Виды_жилья { get; set; }
        public virtual DbSet<Клиенты> Клиенты { get; set; }
        public virtual DbSet<Пансионаты> Пансионаты { get; set; }
        public virtual DbSet<Путевки> Путевки { get; set; }
        public virtual DbSet<Туры> Туры { get; set; }
        public virtual DbSet<Туры_для_триггера> Туры_для_триггера { get; set; }
    }
}
