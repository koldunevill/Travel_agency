//------------------------------------------------------------------------------
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
    using System.Collections.Generic;
    
    public partial class Пансионаты
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Пансионаты()
        {
            this.Виды_жилья = new HashSet<Виды_жилья>();
            this.Путевки = new HashSet<Путевки>();
        }
    
        public int ID_Пансионата { get; set; }
        public string Название { get; set; }
        public string Адрес { get; set; }
        public string Город { get; set; }
        public string Страна { get; set; }
        public string Телефон { get; set; }
        public string Описание_территории { get; set; }
        public int Количество_комнат { get; set; }
        public bool Наличие_бассейна { get; set; }
        public bool Наличие_мед__услуг { get; set; }
        public bool Наличие_спа_салона { get; set; }
        public int Уровень_пансионата { get; set; }
        public Nullable<int> Расстояние_до_моря { get; set; }
        public string Logo { get; set; }


        public string Наличие_мед__услугstring
        {
            get
            {
                if (Наличие_мед__услуг == true)
                    return "Да";
                else
                    return "Нет";
            }
        }
        public string Наличие_спа_салонаstring
        {
            get
            {
                if (Наличие_спа_салона == true)
                    return "Да";
                else
                    return "Нет";
            }
        }

        public string Наличие_бассейнаstring
        {
            get
            {
                if (Наличие_бассейна == true)
                {
                    return "Да";
                }
                else
                    return "Нет";
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Виды_жилья> Виды_жилья { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Путевки> Путевки { get; set; }
    }
}
