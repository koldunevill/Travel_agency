using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
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
    /// Логика взаимодействия для ToursPage.xaml
    /// </summary>
    public partial class ToursPage : Page
    {
        int countRecords = Travel_agencyEntities.GetContext().Туры.Count();
        public ToursPage()
        {
            InitializeComponent();
            ToursListViev.ItemsSource = Travel_agencyEntities.GetContext().Туры.ToList();
            SelectBidHouseCB.SelectedIndex = 0;
            SelectTransportCB.SelectedIndex = 0;
            SelectFoodCB.SelectedIndex = 0;
            RecordTB.Text = $"Количество записей {countRecords} из {countRecords}";
        }


        private void Updatetours()
        {
            var current = Travel_agencyEntities.GetContext().Туры.ToList();
            current = current.Where(f => f.Название.ToLower().Contains(SearchBox.Text.ToLower())).ToList();
          

            if (SelectBidHouseCB.SelectedIndex == 1)
            {
                current = current;
            }
            else if (SelectBidHouseCB.SelectedIndex == 1) 
            {
                current = current.Where(f => f.Категория_жилья_на_ночь == "Гостиница").ToList();
            }
            else if (SelectBidHouseCB.SelectedIndex == 2) 
            {
                current = current.Where(f => f.Категория_жилья_на_ночь == "Отель").ToList();
            }
            else if (SelectBidHouseCB.SelectedIndex == 3) 
            {
                current = current.Where(f => f.Категория_жилья_на_ночь == "Кемпинг").ToList();
            }
            else if (SelectBidHouseCB.SelectedIndex == 4) 
            {
                current = current.Where(f => f.Категория_жилья_на_ночь == "Мотель").ToList();
            }


            if (SelectTransportCB.SelectedIndex == 0)
            {
                current = current;
            }
            else if (SelectTransportCB.SelectedIndex == 1) 
            {
                current = current.Where(f => f.Вид_транспорта == "Автобус").ToList();
            }
            else if (SelectTransportCB.SelectedIndex == 2) 
            {
                current = current.Where(f => f.Вид_транспорта == "Самолет").ToList();
            }
            else if (SelectTransportCB.SelectedIndex == 3) 
            {
                current = current.Where(f => f.Вид_транспорта == "Круизный лайнер").ToList();
            }
            else if (SelectTransportCB.SelectedIndex == 4) 
            {
                current = current.Where(f => f.Вид_транспорта == "Поезд").ToList();
            }


            if (SelectFoodCB.SelectedIndex == 0)
            {
                current = current;
            }
            else if (SelectFoodCB.SelectedIndex == 1) 
            {
                current = current.Where(f => f.Вид_питания == "Одноразовое").ToList();
            }
            else if (SelectFoodCB.SelectedIndex == 2) 
            {
                current = current.Where(f => f.Вид_питания == "Двухразовое").ToList();
            }
            else if (SelectFoodCB.SelectedIndex == 3) 
            {
                current = current.Where(f => f.Вид_питания == "Трехразовое").ToList();
            }
         
            
            if (True.IsChecked == true)
            {
                current = current.OrderBy(f => f.Цена_тура_в_сутки).ToList();
            }
            else if (False.IsChecked == true)
            {
                current = current.OrderByDescending(f => f.Цена_тура_в_сутки).ToList();
            }

            int newcountRecords = current.Count();
            RecordTB.Text = $"Количество записей {newcountRecords} из {countRecords}";

            ToursListViev.ItemsSource = current;
        }

        private void GoBoardingHouse_Click(object sender, RoutedEventArgs e)
        {
            manager.MainFrame.Navigate(new BoardingHouses());
        }

        private void SearchBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            Updatetours();
        }

        private void SelectBidHouseCB_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            Updatetours();
        }

        private void SelectTransportCB_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            Updatetours();
        }

        private void SelectFoodCB_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            Updatetours();
        }

        private void False_Checked(object sender, RoutedEventArgs e)
        {
            Updatetours();
        }

        private void True_Checked(object sender, RoutedEventArgs e)
        {
            Updatetours();
        }

        private void DeleteFiltr_Click(object sender, RoutedEventArgs e)
        {
            True.IsChecked = false;
            False.IsChecked = false;
            Updatetours();
        }

        private void DeleteTour_Click(object sender, RoutedEventArgs e)
        {
            var selectedTour = ToursListViev.SelectedItem as Туры;
            if (selectedTour == null)
            {
                MessageBox.Show("Выберите тур для удаления.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            bool hasRelatedTours = Travel_agencyEntities.GetContext().Путевки
             .Any(t => t.ID_Тура == selectedTour.ID_Тура);

            if (hasRelatedTours)
            {
                MessageBox.Show("Невозможно удалить тур, так как он связан с путёвками.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (MessageBox.Show("Вы точно хотите удалить этот тур?", "Подтверждение удаления", MessageBoxButton.YesNo, MessageBoxImage.Warning) == MessageBoxResult.Yes)
            {
                try
                {
                    Travel_agencyEntities.GetContext().Туры.Remove(selectedTour);
                    Travel_agencyEntities.GetContext().SaveChanges();
                    MessageBox.Show("Тур успешно удалён.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Information);
                    countRecords -= 1;
                    Updatetours();
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
