using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Travel_agency
{
    /// <summary>
    /// Логика взаимодействия для TravelPackagesPage.xaml
    /// </summary>
    public partial class TravelPackagesPage : Page
    {
        int countRecords = Travel_agencyEntities.GetContext().Путевки.Count();
        public TravelPackagesPage()
        {
            InitializeComponent();
            TravePackagesListView.ItemsSource = Travel_agencyEntities.GetContext().Путевки.ToList();
            RecordTB.Text = $"Количество записей {countRecords} из {countRecords}";
        }

        public void UpdateTravekPackage()
        {
            var current = Travel_agencyEntities.GetContext().Путевки.ToList();

            if (ChildYES.IsChecked == true)
            {
                current = current.Where(f => f.Наличие_детей.Equals(true)).ToList();
            }
            if (ChildNO.IsChecked == true)
            {
                current = current.Where(f => f.Наличие_детей.Equals(false)).ToList();
            }
            if (MedYES.IsChecked == true)
            {
                current = current.Where(f => f.Наличие_мед__страховки.Equals(true)).ToList();
            }
            if (MedNO.IsChecked == true)
            {
                current = current.Where(f => f.Наличие_мед__страховки.Equals(false)).ToList();
            }




            current = current.Where(f =>
                (f.Клиенты?.Фамилия?.ToLower().Contains(SearchBox.Text.ToLower()) ?? false) ||
                (f.Клиенты?.Имя?.ToLower().Contains(SearchBox.Text.ToLower()) ?? false) ||
                (f.FIO?.ToLower().Contains(SearchBox.Text.ToLower()) ?? false) ||
                (f.Клиенты?.Отчество?.ToLower().Contains(SearchBox.Text.ToLower()) ?? false) ||
                (f.Туры?.Название?.ToLower().Contains(SearchBox.Text.ToLower()) ?? false) ||
                (f.Пансионаты?.Название?.ToLower().Contains(SearchBox.Text.ToLower()) ?? false) ||
                (f.Виды_жилья?.Название?.ToLower().Contains(SearchBox.Text.ToLower()) ?? false)).ToList();

            TravePackagesListView.ItemsSource = current;
        }


        private void SearchBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            UpdateTravekPackage();
        }

        private void Delete_Click(object sender, RoutedEventArgs e)
        {

        }
        private void GOTours_Click(object sender, RoutedEventArgs e)
        {
            manager.MainFrame.Navigate(new ToursPage());
        }

        private void GoBoardingHouse_Click(object sender, RoutedEventArgs e)
        {
            manager.MainFrame.Navigate(new BoardingHouses());
        }

        private void ChildYES_Checked(object sender, RoutedEventArgs e)
        {
            UpdateTravekPackage();
        }

        private void ChildNO_Checked(object sender, RoutedEventArgs e)
        {
            UpdateTravekPackage();
        }

        private void MedYES_Checked(object sender, RoutedEventArgs e)
        {
            UpdateTravekPackage();
        }

        private void MedNO_Checked(object sender, RoutedEventArgs e)
        {
            UpdateTravekPackage();
        }
    }
}