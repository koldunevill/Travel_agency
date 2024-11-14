using System;
using System.Collections;
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
    /// Логика взаимодействия для BoardingHouses.xaml
    /// </summary>
    public partial class BoardingHouses : Page
    {
        int countRecords = Travel_agencyEntities.GetContext().Пансионаты.Count();
        public BoardingHouses()
        {
            InitializeComponent();

            var currentboardinghouses = Travel_agencyEntities.GetContext().Пансионаты.ToList();
            Boarding_housesLIST.ItemsSource = currentboardinghouses;
            CombodistanceseaCB.SelectedIndex = 0;

            RecordTB.Text = $"Количество записей {countRecords} из {countRecords}";
        }

        private void UpdateBoarding_housesLIST()
        {
            var currentboardinghouses = Travel_agencyEntities.GetContext().Пансионаты.ToList();


            currentboardinghouses = currentboardinghouses.Where(f => f.Название.ToLower().Contains(SearchBox.Text.ToLower())).ToList();

            if (CombodistanceseaCB.SelectedIndex == 0)
            {
                currentboardinghouses = currentboardinghouses.Where(f => f.Расстояние_до_моря>0).ToList();
            }
            else if (CombodistanceseaCB.SelectedIndex == 1)
            {
                currentboardinghouses = currentboardinghouses.Where(f => f.Расстояние_до_моря > 0 && f.Расстояние_до_моря<100).ToList();
            }
            else if (CombodistanceseaCB.SelectedIndex == 2)
            {
                currentboardinghouses = currentboardinghouses.Where(f => f.Расстояние_до_моря >= 100 && f.Расстояние_до_моря < 500).ToList();
            }
            else if (CombodistanceseaCB.SelectedIndex == 3)
            {
                currentboardinghouses = currentboardinghouses.Where(f => f.Расстояние_до_моря >= 500 && f.Расстояние_до_моря <= 1000).ToList();
            }
            
            
            if (Truepool.IsChecked == true)
            {
                currentboardinghouses = currentboardinghouses.Where(f => f.Наличие_бассейна.Equals(true)).ToList();
            }
            if (Falsepool.IsChecked == true)
            {
                currentboardinghouses = currentboardinghouses.Where(f => f.Наличие_бассейна.Equals(false)).ToList();
            }


            if (TruSpa.IsChecked == true)
            {
                currentboardinghouses = currentboardinghouses.Where(f => f.Наличие_спа_салона.Equals(true)).ToList();
            }
            else if (FalSpa.IsChecked == true)
            {
                currentboardinghouses = currentboardinghouses.Where(f => f.Наличие_спа_салона.Equals(false)).ToList();
            }

            if(TruMed.IsChecked == true)
            {
                currentboardinghouses = currentboardinghouses.Where(f => f.Наличие_спа_салона.Equals(true)).ToList();
            }
            else if (FalMed.IsChecked == true)
            {
                currentboardinghouses = currentboardinghouses.Where(f => f.Наличие_мед__услуг.Equals(false)).ToList();
            }

            int newcountRecord = currentboardinghouses.Count;
            RecordTB.Text = $"Количество записей {newcountRecord} из {countRecords}";

            Boarding_housesLIST.ItemsSource = currentboardinghouses;
        }


        private void SearchBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            UpdateBoarding_housesLIST();
        }

        private void CombodistanceseaCB_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            UpdateBoarding_housesLIST();
        }


        private void Truepool_Checked(object sender, RoutedEventArgs e)
        {
            UpdateBoarding_housesLIST();
        }

        private void Falsepool_Checked(object sender, RoutedEventArgs e)
        {
            UpdateBoarding_housesLIST();
        }

        private void TruSpa_Checked(object sender, RoutedEventArgs e)
        {
            UpdateBoarding_housesLIST();
        }

        private void FalSpa_Checked(object sender, RoutedEventArgs e)
        {
            UpdateBoarding_housesLIST();
        }

        private void TruMed_Checked(object sender, RoutedEventArgs e)
        {
            UpdateBoarding_housesLIST();
        }

        private void FalMed_Checked(object sender, RoutedEventArgs e)
        {
            UpdateBoarding_housesLIST();
        }

        private void GoTours_Click(object sender, RoutedEventArgs e)
        {
            manager.MainFrame.Navigate(new ToursPage());
        }

        private void DeleteFiltr_Click(object sender, RoutedEventArgs e)
        {
            Truepool.IsChecked = false;
            Falsepool.IsChecked = false;

            TruSpa.IsChecked = false;
            FalSpa.IsChecked = false;

            TruMed.IsChecked = false;
            FalMed.IsChecked = false;
            UpdateBoarding_housesLIST();
        }



        private void DeleteItem_Click(object sender, RoutedEventArgs e)
        {
            var selectedBoardingHouse = Boarding_housesLIST.SelectedItem as Пансионаты;
            if (selectedBoardingHouse == null)
            {
                MessageBox.Show("Выберите пансионат для удаления.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }


            bool hasRelatedTours = Travel_agencyEntities.GetContext().Путевки
                .Any(t => t.ID_Пансионата == selectedBoardingHouse.ID_Пансионата);

            bool hasRelatedHousingTypes = Travel_agencyEntities.GetContext().Виды_жилья
                .Any(h => h.ID_Пансионата == selectedBoardingHouse.ID_Пансионата);


            if (hasRelatedTours || hasRelatedHousingTypes)
            {
                MessageBox.Show("Невозможно удалить пансионат, так как он связан с путёвками или видами жилья.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }


            if (MessageBox.Show("Вы точно хотите удалить этот пансионат?", "Подтверждение удаления", MessageBoxButton.YesNo, MessageBoxImage.Warning) == MessageBoxResult.Yes)
            {
                try
                {
                    Travel_agencyEntities.GetContext().Пансионаты.Remove(selectedBoardingHouse);
                    Travel_agencyEntities.GetContext().SaveChanges();
                    MessageBox.Show("Пансионат успешно удалён.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Information);
                    countRecords -= 1;
                    UpdateBoarding_housesLIST();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при удалении: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }


        private void GOTravelPackages_Click(object sender, RoutedEventArgs e)
        {
            manager.MainFrame.Navigate(new TravelPackagesPage());
        }

    }
}
